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
  include AudienceSearchMethods
  include AudienceDownloadMethods
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
      if DateTime.now > DateTime.parse('2017-01-01 00:00') 
        minDate = DateTime.now - 45.days 
        error_name = 'passed_45_days'
      else 
        minDate = DateTime.parse('2015-12-10 00:00') 
        error_name = 'passed_time'
      end
      if self.date >= minDate
        date = 'valid'
      else
        date = error_name
      end
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

  def send_publish_email
    UserMailer.audience_new(self).deliver_now
  end
end
