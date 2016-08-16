module AudienceDownloadMethods

  extend ActiveSupport::Concern

  def as_csv 
    DOWNLOAD_HEADERS.collect do |table_attribute| 
      attribute = table_attribute[:methods].inject(self) do |o, a| 
        acum = o.send(*a) 
        if acum.nil? then break '' else acum end
      end
      if attribute.kind_of?(Time)
        attribute.iso8601
      else
        attribute.to_s
      end
    end

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

  module ClassMethods

    def table_types
        [
            :integer, :time, :time, :string, :string, :float, :float, :string, :string, :string,
            :string, :string, :string, :string, :string, :string, 
            :string, :string, :string, :string, :string, :string,
            :string, :string, :string, :string, :string,
            :string, :string, :string,
            :string, :string, :string,
            :string, :string,
            :string
        ]
    end

    def table_headers
      DOWNLOAD_HEADERS.collect { |table_attribute| table_attribute[:name] }
    end

  end

end
