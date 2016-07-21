module AudienceSearchMethods

  extend ActiveSupport::Concern

  module ClassMethods
    SEARCH_ALIASES = HashWithIndifferentAccess.new({
      'persona' => '_people',
      'pen' => '_dependency',
      'interes-invocado' => '_interest_invoked',
      'persona-juridica' => '_represented_entity',
      'grupo-de-personas' => '_represented_group',
      'organismo-estatal' => '_represented_organism'
    })

    def search_options(options={})
      query = parse_query(options)

      should_filters = []
      must_filters = []

      date_filter = parse_dates(options)
      must_filters << date_filter if date_filter

      nested_filters = parse_nested_filters(options)
      must_filters += nested_filters if nested_filters

      aggregations = parse_aggregations(options)

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

    def parse_nested_filters(options)
      filters = []
      SEARCH_ALIASES.each do |k, v|
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
          
          filters << nested_filter
        end
      end
      filters
    end

    def parse_aggregations(options)
      aggregations = {}
      SEARCH_ALIASES.each do |k, v|
        unless options[k]
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
      aggregations
    end

    def shortcut_aggregations
      query = make_query({
        aggregations: {
          _dependency: {
            nested: {
              path: '_dependency'
            },
            aggs: {
              ids: {
                terms: {
                  field: "_dependency.id",
                  size: 50
                },
                aggs: {
                  name: {
                    terms: {
                      field: "_dependency.name"
                    }
                  }
                }  
              }
            }
          },
          _obligee: {
            nested: {
              path: '_people'
            },
            aggs: {
              _obligees: {
                filter: { term: { '_people.role' => 'obligee' } },
                aggs: {
                  ids: {
                    terms: {
                      field: "_people.id",
                      size: 50
                    },
                    aggs: {
                      name: {
                        terms: {
                          field: "_people.name"
                        }
                      }
                    }  
                  }
                }
              }
            }
          },
          _applicant: {
            nested: {
              path: '_people'
            },
            aggs: {
              _applicants: {
                filter: { term: { '_people.role' => 'applicant' } },
                aggs: {
                  ids: {
                    terms: {
                      field: "_people.id",
                      size: 50
                    },
                    aggs: {
                      name: {
                        terms: {
                          field: "_people.name"
                        }
                      }
                    }  
                  }
                }
              }
            }
          }
        }
      })
      default_aggregations = parse_aggregations({})
      query[:aggs][:_dependency] = default_aggregations['_dependency']
      query[:aggs][:_represented_entity] = default_aggregations['_represented_entity']
      query[:aggs][:_represented_group] = default_aggregations['_represented_group']
      query[:aggs][:_represented_organism] = default_aggregations['_represented_organism']
      self.search(query).response['aggregations']
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
      query = { 
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
        }
      }
      query[:sort] = options[:sort] if options[:sort]
      query[:aggs] = options[:aggregations] if options[:aggregations]
      query[:query][:filtered][:filter][:bool][:must] += options[:must_filters] if options[:must_filters]
      query[:query][:filtered][:filter][:bool][:should] = options[:should_filters] if options[:should_filters]
      query[:query][:filtered][:query] = options[:query] if options[:query]
      query
    end
  end

end