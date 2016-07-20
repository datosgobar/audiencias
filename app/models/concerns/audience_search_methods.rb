module AudienceSearchMethods

  extend ActiveSupport::Concern

  module ClassMethods
    def search_options(options={})
      query = parse_query(options)

      should_filters = []
      must_filters = [
        { term: { "published" => true } },
        { term: { "deleted" => false } }
      ]

      date_filter = parse_dates(options)
      must_filters << date_filter if date_filter
      
      aggregations = {}
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
          nested_filter = { nested: { path: v, query: { bool: { must: [], must_not: [] } } } }
          nested_filter[:nested][:query][:bool][:must] << { term: { "#{v}.id" => options[k] } }

          if k == 'persona' and options['roles-persona']
            roles = options['roles-persona'].split('-')
            role_translations = { 'obligado' => 'obligee', 'participante' => 'participant', 'representado' => 'represented', 'solicitante' => 'applicant'}
            role_translations.each do |k, v|
              if not roles.include?(k)
                nested_filter[:nested][:query][:bool][:must_not] << { term: { "_people.role" => v } }
              end
            end
          end
          
          must_filters << nested_filter
        else
          aggregations[v] = {
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
      make_query({
        sort: { date: :desc },
        query: query,
        must_filters: must_filters,
        should_filters: should_filters,
        aggregations: aggregations
      })
    end

    def parse_query(options)
      has_query = !!options['q']
      return nil unless has_query

      searching_specific = !!(
        options['buscar-persona'] or 
        options['buscar-pen'] or 
        options['buscar-textos'] or 
        options['buscar-representado']
      )
      
      return { match: { "_all" => options['q'] } } if has_query and not searching_specific
      
      should_fields = []
      if options['buscar-persona']
        should_fields << { 
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
        should_fields << { 
          match: { 
            "obligee.dependency.name" => options['q']
          } 
        }
      end
      if options['buscar-textos']
        should_fields << { 
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
        should_fields << { 
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
      return { bool: { should: should_fields }}
    end

    def parse_dates(options) 
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
        
        return date_filter
      end
    end

    def public_search(options={})
      self.search(search_options(options))
    end

    def operator_search(query, person_id) 
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

    def make_query(options)
      { 
        sort: options[:sort],
        query: { 
          filtered: { 
            query: options[:query],
            filter: { 
              bool: {
                must: options[:must_filters],
                should: options[:should_filters]
              } 
            } 
          } 
        },
        aggs: options[:aggregations] 
      }
    end
  end

end