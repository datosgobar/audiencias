require 'elasticsearch/model'

class Audience < ActiveRecord::Base

  belongs_to :author, foreign_key: 'author_id', class_name: 'User'
  belongs_to :obligee
  belongs_to :applicant, autosave: true
  has_many :participants, autosave: true

  validates :author, presence: true
  validates :obligee, presence: true
  validates :summary, length: { maximum: 1000 }, allow_blank: true
  validates :place, length: { maximum: 200 }, allow_blank: true
  validates :motif, length: { maximum: 200 }, allow_blank: true
  validates :address, length: { maximum: 200 }, allow_blank: true

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  self.per_page = 15
  
  AS_JSON_OPTIONS =  {
    only: [ :date, :publish_date, :summary, :interest_invoked, :address,
      :published, :place, :created_at, :lat, :lng, :id, :motif, :deleted ],
    include: { 
      author: User::AS_JSON_OPTIONS,
      applicant: Applicant::AS_JSON_OPTIONS,
      obligee: Obligee::AS_JSON_OPTIONS,
      participants: Participant::AS_JSON_OPTIONS
    },
    methods: [ :state, :publish_validations ]
  }
  AS_PUBLIC_JSON_OPTIONS = {
    only: [ :date, :publish_date, :summary, :interest_invoked, :address,
      :published, :place, :lat, :lng, :id, :motif ],
    include: { 
      applicant: Applicant::AS_PUBLIC_JSON_OPTIONS,
      obligee: Obligee::AS_PUBLIC_JSON_OPTIONS,
      participants: Participant::AS_PUBLIC_JSON_OPTIONS
    }
  }
  def as_json(options={})
    if options[:for_public]
      super(AS_PUBLIC_JSON_OPTIONS)
    else
      super(AS_JSON_OPTIONS)
    end
  end

  def as_indexed_json(options={})
    json = self.as_json
    json['_people'] = self.people
    json['_dependency'] = self.obligee.dependency.as_json(minimal: true)
    if self.applicant
      a = self.applicant
      json['_represented_entity'] = a.represented_legal_entity.as_json(minimal: true) if a.represented_legal_entity
      json['_represented_organism'] = a.represented_state_organism.as_json(minimal: true) if a.represented_state_organism
      json['_represented_group'] = a.represented_people_group.as_json(minimal: true) if a.represented_people_group
    end
    json['_interest_invoked'] = { 'id' => interest_invoked, 'name' => if interest_invoked then interest_invoked.titleize else nil end }
    json
  end

  def people
    p = []

    if self.obligee
      person_json = self.obligee.person.as_json(minimal: true)
      person_json['role'] = 'obligee'
      p << person_json
    end

    if self.applicant
      person_json = self.applicant.person.as_json(minimal: true)
      person_json['role'] = 'applicant'
      p << person_json
    end

    if self.applicant and self.applicant.represented_person
      person_json = self.applicant.represented_person.as_json(minimal: true)
      person_json['role'] = 'represented'
      p << person_json
    end

    self.participants.each do |participant| 
      person_json = participant.person.as_json(minimal: true)
      person_json['role'] = 'participant'
      p << person_json
    end

    p
  end

  def self.search_options(options={})
    search_options = {
      sort: { date: :desc },
      query: {
        filtered: {
          filter: {
            bool: {
              must: [
                { term: { "published" => true } },
                { term: { "deleted" => false } }
              ]
            }
          }
        }
      },
      aggs: {}
    }

    if options['q']
      if options['buscar-persona'] or options['buscar-pen'] or options['buscar-textos'] or options['buscar-representado']
        query = { bool: { should: [] }}
        if options['buscar-persona']
          query[:bool][:should] << { 
            multi_match: { 
              "query" => options['q'],
              "fields" => [
                "applicant.person.name",
                "applicant.person.person_id",
                "obligee.person.name",
                "obligee.person.person_id",
                "participants.person.name",
                "participants.person.person_id"
              ]
            } 
          }
        end
        if options['buscar-pen']
          query[:bool][:should] << { 
            match: { 
              "obligee.dependency.name" => options['q']
            } 
          }
        end
        if options['buscar-textos']
          query[:bool][:should] << { 
            multi_match: { 
              "query" => options['q'],
              "fields" => [
                "summary",
                "motif"
              ]
            } 
          }
        end
        if options['buscar-representado']
          query[:bool][:should] << { 
            multi_match: { 
              "query" => options['q'],
              "fields" => [
                "applicant.represented_person.name",
                "applicant.represented_legal_entity.name",
                "applicant.represented_state_organism.name",
                "applicant.represented_people_group.name"
              ]
            } 
          }
        end
        search_options[:query][:filtered][:query] = query
      else
        search_options[:query][:filtered][:query] = { match: { "_all" => options['q'] } }
      end
    end

    if options['desde'] or options['hasta']
      date_filter = { range: { date: {} } }
      
      if options['desde']
        fromDate = Time.parse(options['desde']).iso8601()
        date_filter[:range][:date]["gte"] = fromDate 
      end
      if options['hasta']
        toDate = (Time.zone.parse(options['hasta']) + 1.day).iso8601()
        date_filter[:range][:date]["lt"] = toDate
      end
      search_options[:query][:filtered][:filter][:bool][:must] << date_filter
    end

    aliases = HashWithIndifferentAccess.new({
      'persona' => '_people',
      'pen' => '_dependency',
      'interes-invocado' => '_interest_invoked',
      'persona-juridica' => '_represented_entity',
      'grupo-de-personas' => '_represented_group',
      'organismo-estatal' => '_represented_organism'
    })
    aliases.each do |k, v|
      if options[k]
        filter = { term: { "#{v}.id" => options[k] } }
        search_options[:query][:filtered][:filter][:bool][:must] << filter

        if k == 'persona' and options['roles-persona']
          roles = options['roles-persona'].split('-')
          role_translations = { 'obligado' => 'obligee'}
          nested_filter = { nested: { path: '_people', query: { bool: { must: [] }} } }
          roles.each do |role|
            role_filter = { term: { "_people.role" => role_translations[role] } }

          end
          search_options[:query][:filtered][:filter][:bool][:must] << nested_filter
        end
        
      else
        search_options[:aggs][v] = {
          nested: {
            path: v
          },
          aggs: {
            ids: {
              terms: {
                field: "#{v}.id",
                size: 50
              },
              aggs: {
                name: {
                  terms: {
                    field: "#{v}.name"
                  }
                }
              }  
            }
          }
        }
      end
    end
    search_options
  end

  def self.public_search(options={})
    self.search(search_options(options))
  end

  def self.operator_search(query, person_id) 
    self.search({
      sort: { created_at: :desc },
      query: {
        filtered: {
          query: {
            multi_match: {
              query: query,
              fields: [
                'author.name', 
                'applicant.person.name', 
                'applicant.ocupation',
                'applicant.person.email',
                'applicant.represented_person.name', 
                'applicant.represented_legal_entity.name',
                'applicant.represented_state_organism.name',
                'applicant.represented_people_group.name', 
                'motif'
              ]
            }
          },
          filter: {
            bool: {
              should: [
                { term: { "obligee.person.id" => person_id } }, 
                { term: { "applicant.person.id" => person_id } },
                { terms: { "participants.person.id" => [person_id] } }
              ],
              must: [{
                term: {
                  "deleted" => false
                }
              }]
            }
          }
        }
      }
    })
  end

  def update_minor_attributes(params)
    self.date = params[:date] if params[:date]
    self.summary = params[:summary] if params[:summary]
    self.interest_invoked = params[:interest_invoked] if params[:interest_invoked]
    self.place = params[:place] if params[:place]
    self.lat = params[:lat] if params[:lat]
    self.lng = params[:lng] if params[:lng]
    self.address = params[:address] if params[:address]
    self.motif = params[:motif] if params[:motif]

    if params[:applicant]
      self.applicant = Applicant.new unless self.applicant
      self.applicant.update_minor_attributes(params[:applicant])
      self.applicant.save
    end

    if params[:participant]
      id_type = params[:participant][:person][:id_type]
      person_id = params[:participant][:person][:person_id]
      participant = self.participants.find { |p| p.person.id_type == id_type and p.person.person_id == person_id }
      participant = Participant.new(audience: self) unless participant
      participant.update_minor_attributes(params[:participant])
      participant.save
      self.participants << participant unless self.participants.include?(participant)
    end
  end

  def publish_validations
    if self.date && self.date < DateTime.now
      date = 'valid'
    elsif self.date 
      date = 'not_yet_valid'
    else 
      date = 'incomplete'
    end

    proper_fields_validation = if (
      self.date && 
      self.summary && 
      self.summary.length > 0 && 
      self.interest_invoked && 
      ['particular', 'difuso', 'colectivo'].include?(self.interest_invoked) && 
      self.place && 
      self.place.length > 0 && 
      self.address && 
      self.address.length > 0 &&
      self.author && 
      self.obligee && 
      self.motif && 
      self.motif.length > 0) then 'valid' else 'incomplete' end

    if self.applicant and self.applicant.absent
      total_participants = self.participants.length 
    elsif self.applicant
      total_participants = self.participants.length + 1
    else
      total_participants = 0
    end
    presence_validation = if total_participants > 0 then 'valid' else 'incomplete' end
    applicant_validation = if self.applicant then self.applicant.publish_validations else 'incomplete' end
    participants_validations = self.participants.collect(&:publish_validations)
    fields_validations = [proper_fields_validation, applicant_validation] + participants_validations

    if fields_validations.all? { |validation| validation == 'valid' }
      fields = 'valid'
    else
      fields = 'incomplete'
    end
    { date: date, participants: presence_validation, fields: fields }
  end

  def state 
    validations = publish_validations
    if validations[:date] == 'valid' && validations[:fields] == 'valid' && validations[:participants] == 'valid'
      'valid'
    else
      'incomplete'
    end
  end

  def includes_query?(query)
    false
  end

  DOWNLOAD_HEADERS = [
    { methods: [:id], name: 'id' },
    { methods: [:date], name: 'fecha' },
    { methods: [:publish_date], name: 'fecha_de_publicacion' },
    { methods: [:summary], name: 'sintesis' },
    { methods: [:place], name: 'lugar' },
    { methods: [:lat], name: 'lat' },
    { methods: [:lng], name: 'lng' },
    { methods: [:motif], name: 'motivo' },
    { methods: [:interest_invoked], name: 'interes_invocado' },
    { methods: [:address], name: 'direccion' },

    { methods: [:obligee, :person, :person_id], name: 'sujeto_obligado_id'},
    { methods: [:obligee, :person, :name], name: 'sujeto_obligado_nombre'},
    { methods: [:obligee, :person, :id_type], name: 'sujeto_obligado_tipo_id'},
    { methods: [:obligee, :person, :country], name: 'sujeto_obligado_pais'},
    { methods: [:obligee, :position], name: 'sujeto_obligado_cargo'},
    { methods: [:obligee, :dependency, :name], name: 'sujeto_obligado_dependencia'},

    { methods: [:applicant, :person, :person_id], name: 'solicitante_id' },
    { methods: [:applicant, :person, :id_type], name: 'solicitante_tipo_id' },
    { methods: [:applicant, :person, :name], name: 'solicitante_nombre' },
    { methods: [:applicant, :person, :country], name: 'solicitante_pais' },
    { methods: [:applicant, :ocupation], name: 'solicitante_ocupacion' },
    { methods: [:applicant, :absent, :!], name: 'solicitante_presente' },

    { methods: [:applicant, :represented_person, :person_id], name: 'persona_representada_id' },
    { methods: [:applicant, :represented_person, :id_type], name: 'persona_representada_tipo_id' },
    { methods: [:applicant, :represented_person, :name], name: 'persona_representada_nombre' },
    { methods: [:applicant, :represented_person, :country], name: 'persona_representada_pais' },
    { methods: [:applicant, :represented_person_ocupation], name: 'persona_representada_ocupacion' },

    { methods: [:applicant, :represented_legal_entity, :name], name: 'persona_juridica_representada_nombre' },
    { methods: [:applicant, :represented_legal_entity, :country], name: 'persona_juridica_representada_pais' },
    { methods: [:applicant, :represented_legal_entity, :cuit], name: 'persona_juridica_representada_cuit' },

    { methods: [:applicant, :represented_people_group, :name], name: 'grupo_de_personas_representado_nombre' },
    { methods: [:applicant, :represented_people_group, :description], name: 'grupo_de_personas_representado_descripcion' },
    { methods: [:applicant, :represented_people_group, :country], name: 'grupo_de_personas_representado_pais' },

    { methods: [:applicant, :represented_state_organism, :name], name: 'organismo_estatal_representado_nombre' },
    { methods: [:applicant, :represented_state_organism, :country], name: 'organismo_estatal_representado_pais' },

    { methods: [:participants, [:to_json, {spanish: true}]], name: 'participantes_json' }
  ]
  def self.table_headers
    DOWNLOAD_HEADERS.collect { |table_attribute| table_attribute[:name] }
  end

  def as_csv 
    DOWNLOAD_HEADERS.collect do |table_attribute| 
      table_attribute[:methods].inject(self) do |o, a| 
        acum = o.send(*a) 
        if acum.nil? then break '' else acum end
      end
    end

  end

  def send_publish_email
    UserMailer.audience_new(self).deliver_now
  end
end
