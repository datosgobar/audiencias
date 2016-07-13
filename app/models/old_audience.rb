require 'elasticsearch/model'

class OldAudience < ActiveRecord::Base

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  self.per_page = 15


def self.search_options(options={})
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
        fromDate = Date.parse(options['desde'], "%d-%m-%Y").iso8601()
        date_filter[:range][:fecha_hora_audiencia]["gte"] = fromDate 
      end
      if options['hasta']
        toDate = Date.parse(options['hasta'], "%d-%m-%Y").iso8601()
        date_filter[:range][:fecha_hora_audiencia]["lte"] = toDate
      end
      search_options[:query][:filtered][:filter][:bool][:must] << date_filter
    end

    search_options
  end

  def self.public_search(options={})
    self.search(search_options(options))
  end

end

OldAudience.import
