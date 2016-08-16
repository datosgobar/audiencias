module OldAudienceSearchMethods

  extend ActiveSupport::Concern

  module ClassMethods
    def search_options(options={})
      search_options = {
        sort: { fecha_hora_audiencia: :desc },
        query: {
          filtered: {
            filter: {
              bool: {
                must: []
              }
            }
          }
        }
      }

      if options['q']
        search_options[:query][:filtered][:query] = { match: { "_all" => options['q'] } }
      end

      if options['desde'] or options['hasta']
        date_filter = { range: { fecha_hora_audiencia: {} } }
        
        if options['desde']
          fromDate = Time.parse(options['desde']).iso8601()
          date_filter[:range][:fecha_hora_audiencia]["gte"] = fromDate 
        end
        if options['hasta']
          toDate = (Time.zone.parse(options['hasta']) + 1.day).iso8601()
          date_filter[:range][:fecha_hora_audiencia]["lte"] = toDate
        end
        search_options[:query][:filtered][:filter][:bool][:must] << date_filter
      end

      search_options
    end

    def public_search(options={})
      self.search(search_options(options))
    end
  end

end