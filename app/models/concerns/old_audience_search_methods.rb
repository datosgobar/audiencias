module OldAudienceSearchMethods

  extend ActiveSupport::Concern

  module ClassMethods
    def search_options(options={})
      search_options = {
        sort: [
          '_score',
          { fecha_hora_audiencia: :desc }
        ],
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
        options['q'].split(' ').each do |term|
          search_options[:query][:filtered][:filter][:bool][:must] << { match: { "_all" => term } }
        end
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