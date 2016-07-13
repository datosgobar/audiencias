class CreateOldAudiencesTable < ActiveRecord::Migration

  def change

    create_table :old_audiences do |t|

      t.integer :id_audiencia, index: true
      t.string :apellido_sujeto_obligado
      t.string :nombre_sujeto_obligado
      t.string :cargo_sujeto_obligado
      t.string :dependencia_sujeto_obligado
      t.string :super_dependencia
      t.datetime :fecha_solicitud_audiencia
      t.string :apellido_solicitante
      t.string :nombre_solicitante
      t.string :cargo_solicitante
      t.string :tipo_documento_solicitante
      t.string :numero_documento_solicitante
      t.string :interes_invocado
      t.string :caracter_en_que_participa
      t.string :apellido_descripcion_representado
      t.string :nombre_representado
      t.string :cargo_representado
      t.string :domicilio_representado
      t.string :numero_documento_representadoo
      t.datetime :fecha_hora_audiencia
      t.string :lugar_audiencia
      t.string :objeto_audiencia
      t.string :participante_audiencia
      t.string :estado_cancelada_audiencia
      t.string :estado_audiencia
      t.string :sintesis_audiencia
      t.timestamps

    end

  end 
end 
