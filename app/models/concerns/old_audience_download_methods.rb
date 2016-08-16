module OldAudienceDownloadMethods

  extend ActiveSupport::Concern

  CSV_HEADERS = %w{id_audiencia apellido_sujeto_obligado nombre_sujeto_obligado cargo_sujeto_obligado
  dependencia_sujeto_obligado super_dependencia fecha_solicitud_audiencia apellido_solicitante
  nombre_solicitante cargo_solicitante tipo_documento_solicitante numero_documento_solicitante
  interes_invocado caracter_en_que_participa apellido_descripcion_representado nombre_representado
  cargo_representado domicilio_representado numero_documento_representadoo fecha_hora_audiencia
  lugar_audiencia objeto_audiencia participante_audiencia estado_cancelada_audiencia estado_audiencia
  sintesis_audiencia }

  def as_csv 
    CSV_HEADERS.collect{ |attr| self[attr] }
  end

  module ClassMethods

    def table_types
      [
        :integer, :string, :string, :string, :string, :string, :time, :string,
        :string, :string, :string, :string, :string, :string, :string, :string, :string, 
        :string, :string, :time, :string, :string, :string, :string, :string, :string
      ]
    end

    def table_headers
      CSV_HEADERS
    end
  end
end




