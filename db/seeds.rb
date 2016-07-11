require 'faker'

def initialize_random_of(klass, conditions={})
  
  if klass == AdminAssociation
    AdminAssociation.new({
      dependency: Dependency.all.sample,
      user: User.all.sample  
    })
  
  elsif klass == Applicant
    applicant = Applicant.new({
      absent: [false, true].sample,
      person: Person.all.sample,
      audience: conditions[:audience],
      ocupation: Faker::Company.profession
    })
    representation = [nil, 'person', 'legal_entity', 'state_organism', 'people_group']
    if representation == 'person'
      applicant.represented_person = Person.all.sample
      applicant.represented_person_ocupation = Faker::Company.profession
    elsif representation == 'legal_entity'
      applicant.represented_legal_entity = LegalEntity.all.sample
    elsif representation == 'state_organism'
      applicant.represented_state_organism = StateOrganism.all.sample
    elsif representation == 'people_group'
      applicant.represented_people_group = PeopleGroup.all.sample
    end
    applicant

  elsif klass == Audience
    audience = Audience.new({
      date: Faker::Time.between(DateTime.now - 1.year, DateTime.now),
      summary: Faker::Lorem.paragraph[0..999],
      place: Faker::Address.city,
      address: "#{Faker::Address.street_address}, #{Faker::Address.city}, #{Faker::Address.country}",
      obligee: Obligee.all.sample,
      lat: Faker::Address.latitude,
      lng: Faker::Address.longitude,
      motif: Faker::Lorem.paragraph[0..199],
      author: User.all.sample,
      interest_invoked: ['particular', 'difuso', 'colectivo'].sample
    })
    if conditions[:published]
      audience.publish_date = audience.date + 1.day
      audience.published = true
    end
    audience.applicant = initialize_random_of(Applicant, { audience: audience })
    audience.applicant.save
    [0, 1, 2, 3, 4, 6, 8].sample.times do 
      participant = initialize_random_of(Participant, { audience: audience })
      participant.save
    end
    audience
  
  elsif klass == Dependency
    dependency = Dependency.new({
      name: Faker::Company.name
    })
    dependency.parent_id = Dependency.all.sample.id if conditions[:not] and conditions[:parent_id].nil?
    dependency.active = false if conditions[:active] == false
    dependency

  elsif klass == LegalEntity
    entity = LegalEntity.new({
      country: ['Argentina', GLOBALS::COUNTRIES.sample].sample,
      name: Faker::Company.name,
      email: [nil, Faker::Internet.email].sample,
      telephone: [nil, Faker::PhoneNumber.phone_number[0..19]].sample
    })
    if entity.country == 'Argentina'
      entity.cuit = Faker::Number.number(8)
    end
    entity

  elsif klass == Obligee
    obligee = Obligee.new({
      person_id: Faker::Number.number(8),
      position: Faker::Company.profession,
      person: Person.all.sample
    })

    dependencies_without_obligee = Dependency.where(obligee_id: nil)
    if dependencies_without_obligee.count > 0
      dependency = dependencies_without_obligee.all.sample
    else
      dependency = initialize_random_of(Dependency)
    end
    obligee.dependency = dependency
    dependency.obligee = obligee
    dependency.save
    obligee

  elsif klass == OperatorAssociation
    OperatorAssociation.new({
      obligee: Obligee.all.sample,
      user: User.all.sample  
    })

  elsif klass == Participant 
    Participant.new({
      audience: conditions[:audience],
      person: Person.all.sample,
      ocupation: Faker::Company.profession
    })

  elsif klass == Person

    person = Person.new({
      person_id: Faker::Number.number(8),
      name: "#{Faker::Name.last_name } #{Faker::Name.first_name}",
      telephone: [nil, Faker::PhoneNumber.phone_number[0..19]].sample,
      email: Faker::Internet.email,
      country: ['Argentina', GLOBALS::COUNTRIES.sample].sample
    })
    person.id_type = if person.country == 'Argentina' then ['dni', 'lc', 'le'].sample else '' end
    person  

  elsif klass == PeopleGroup

    PeopleGroup.new({
      country: ['Argentina', GLOBALS::COUNTRIES.sample].sample,
      name: Faker::Company.name,
      email: Faker::Internet.email,
      telephone: [nil, Faker::PhoneNumber.phone_number[0..19]].sample,
      description: ['', Faker::Lorem.paragraph[0..199]].sample
    })

  elsif klass == StateOrganism

    StateOrganism.new({
      country: ['Argentina', GLOBALS::COUNTRIES.sample].sample,
      name: Faker::Company.name
    })

  elsif klass == User

    User.new({
      person_id: Faker::Number.number(8),
      name: "#{Faker::Name.last_name } #{Faker::Name.first_name}",
      email: Faker::Internet.email,
      telephone: [nil, Faker::PhoneNumber.phone_number].sample,
      password: Faker::Internet.password,
      is_superadmin: false,
      id_type: ['dni', 'lc', 'le'].sample
    })

  end
end

def have_at_least(min_numer, klass, conditions={})
  if conditions[:not]
    klass_count = klass.where.not(conditions[:not]).count
  else
    klass_count = klass.where(conditions).count
  end

  to_create = min_numer - klass_count
  conditions_string = if conditions.length > 0 then "with #{conditions}" else "" end
  if to_create > 0
    created = 0
    puts "Creating #{to_create} #{klass.name} #{conditions_string}"
    to_create.times do 
      instance = initialize_random_of(klass, conditions)
      created = created + 1 if instance.save!
      unless instance.valid?
        puts instance.erros.full_messages
      end
    end
    puts "#{created} #{klass.name} created #{conditions_string}"
  else
    puts "There already are #{klass_count} #{klass.name} #{conditions_string}"
  end
end

have_at_least 500, Person
have_at_least 300, User 
have_at_least 20, Dependency, { parent_id: nil }
have_at_least 200, Dependency, { not: { parent_id: nil } }
have_at_least 30, Dependency, { active: false }
have_at_least 200, Obligee
have_at_least 20, AdminAssociation
have_at_least 200, OperatorAssociation
have_at_least 100, PeopleGroup
have_at_least 100, StateOrganism
have_at_least 100, LegalEntity
have_at_least 200, Audience, { published: true }