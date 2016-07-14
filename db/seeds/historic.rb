require 'csv'

# Los siguientes parametros (separador, encoding) se tomaron en base al 
# csv de ejemplo proporcionado por mininterior. Cambiar segun corresponda.
# El unico requerimiento fuerte sobre el csv es el nombre de sus columas
# Estas deben ser:
# id_audiencia, apellido_sujeto_obligado, nombre_sujeto_obligado
# cargo_sujeto_obligado, dependencia_sujeto_obligado, super_dependencia
# fecha_solicitud_audiencia, apellido_solicitante, nombre_solicitante
# cargo_solicitante, tipo_documento_solicitante, numero_documento_solicitante
# interes_invocado, caracter_en_que_participa, apellido_descripcion_representado
# nombre_representado, cargo_representado, domicilio_representado
# numero_documento_representadoo, fecha_hora_audiencia, lugar_audiencia
# objeto_audiencia, participante_audiencia, estado_cancelada_audiencia
# estado_audiencia, sintesis_audiencia

csv_path = Rails.root.join('db', 'seeds', 'audiencias.csv')
csv_options = { col_sep: ';', encoding: 'ISO-8859-1', headers: true }

audiences_created = 0
ActiveRecord::Base.transaction do

  CSV.open(csv_path, 'r', csv_options).each do |line|
    line_hash = {}
    line.as_json.each { |value_pair| line_hash[value_pair[0]] = value_pair[1] }

    audience = OldAudience.where(id_audiencia: line_hash['id_audiencia']).first_or_initialize
    new_audience = audience.new_record?
    audience.update_attributes(line_hash)
    audiences_created += 1 if new_audience and audience.save

  end
  
end

puts "#{audiences_created} audiences created"