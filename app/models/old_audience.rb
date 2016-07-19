require 'elasticsearch/model'

class OldAudience < ActiveRecord::Base

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  self.per_page = 15


  def as_json(options={})
    options[:except] ||= [:created_at, :updated_at]
    super(options)
  end

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

  def self.public_search(options={})
    self.search(search_options(options))
  end

  CSV_HEADERS = %w{id_audiencia apellido_sujeto_obligado nombre_sujeto_obligado cargo_sujeto_obligado
    dependencia_sujeto_obligado super_dependencia fecha_solicitud_audiencia apellido_solicitante
    nombre_solicitante cargo_solicitante tipo_documento_solicitante numero_documento_solicitante
    interes_invocado caracter_en_que_participa apellido_descripcion_representado nombre_representado
    cargo_representado domicilio_representado numero_documento_representadoo fecha_hora_audiencia
    lugar_audiencia objeto_audiencia participante_audiencia estado_cancelada_audiencia estado_audiencia
    sintesis_audiencia }

  def self.table_headers
    CSV_HEADERS
  end

  def as_csv 
    CSV_HEADERS.collect{ |attr| self[attr] }
  end

end