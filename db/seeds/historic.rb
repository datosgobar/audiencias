require 'csv'

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