class Applicant < ActiveRecord::Base
  has_one :audience
  belongs_to :person
  belongs_to :represented_person, foreign_key: 'represented_person_id', class_name: 'Person'
  belongs_to :represented_legal_entity, foreign_key: 'represented_legal_entity_id', class_name: 'LegalEntity'
  belongs_to :represented_state_organism, foreign_key: 'represented_state_organism_id', class_name: 'StateOrganism'
  belongs_to :represented_people_group, foreign_key: 'represented_people_group_id', class_name: 'PeopleGroup'

  validates :ocupation, length: { maximum: 200 }, allow_blank: true
  validates :represented_person_ocupation, length: { maximum: 200 }, allow_blank: true
  validate :applicant_cant_be_the_obligee
  validate :represented_person_cant_be_the_obligee
  validate :applicant_cant_represent_itself
  validate :applicant_cant_be_also_a_participant
  validate :represented_person_cant_be_also_a_participant

  AS_JSON_OPTIONS = {
    only: [ :id, :ocupation, :represented_person_ocupation, :absent ],
    include: {
      person: Person::AS_JSON_OPTIONS,
      represented_person: Person::AS_JSON_OPTIONS,
      represented_legal_entity: LegalEntity::AS_JSON_OPTIONS,
      represented_state_organism: {},
      represented_people_group: {}
    },
    methods: [:publish_validations]
  }
  def as_json(options={})
    super(AS_JSON_OPTIONS)
  end

  def update_minor_attributes(params)
    self.ocupation = params[:ocupation].mb_chars.upcase if params.include?(:ocupation)
    self.absent = params[:absent] if params.include?(:absent)

    if params[:person]
      self.person = Person.find_or_initialize(params[:person])
      self.person.update_minor_attributes(params[:person])
      self.person.save
    end

    if params[:represented_people_group]
      self.represented_person = nil
      self.represented_person_ocupation = nil
      self.represented_legal_entity = nil
      self.represented_state_organism = nil
      self.represented_people_group = PeopleGroup.new() unless self.represented_people_group
      self.represented_people_group.update_minor_attributes(params[:represented_people_group])
      self.represented_people_group.save

    elsif params[:represented_state_organism]
      self.represented_person = nil
      self.represented_person_ocupation = nil
      self.represented_legal_entity = nil
      self.represented_people_group = nil
      self.represented_state_organism = StateOrganism.new unless self.represented_state_organism
      self.represented_state_organism.update_minor_attributes(params[:represented_state_organism])
      self.represented_state_organism.save

    elsif params[:represented_legal_entity]
      self.represented_person = nil
      self.represented_person_ocupation = nil
      self.represented_state_organism = nil
      self.represented_people_group = nil
      self.represented_legal_entity = LegalEntity.new unless self.represented_legal_entity
      self.represented_legal_entity.update_minor_attributes(params[:represented_legal_entity])
      self.represented_legal_entity.save

    elsif params[:represented_person]
      self.represented_legal_entity = nil
      self.represented_state_organism = nil
      self.represented_people_group = nil
      self.represented_person_ocupation = params[:represented_person][:ocupation].mb_chars.upcase if params[:represented_person].include?(:ocupation)
      self.represented_person = Person.find_or_initialize(params[:represented_person])
      self.represented_person.update_minor_attributes(params[:represented_person])
      self.represented_person.save
    end
  end

  def remove_represented
    self.represented_person = nil
    self.represented_person_ocupation = nil
    self.represented_legal_entity = nil
    self.represented_state_organism = nil
    self.represented_people_group = nil
  end

  def publish_validations
    proper_validation = if (
      self.ocupation and
      self.ocupation.length > 0 and
      self.person and
      self.person.email and
      self.person.email.length > 0 and
      [false, true].include?(self.absent)) then 'valid' else  'incomplete'  end
    
    if self.represented_person
      represented_validation = if (
        self.represented_person_ocupation and 
        self.represented_person_ocupation.length > 0) then 'valid' else 'incomplete' end
    else 
      represented_validation = 'valid'
    end

    if proper_validation == 'valid' and represented_validation == 'valid'
      'valid'
    else
      'incomplete'
    end
  end

  def applicant_cant_be_also_a_participant
    if self.audience and self.audience.participants and self.audience.participants.length > 0
      if self.audience.participants.any? { |p| p.person == self.person }
        errors.add(:person, "can't be also a participant")
      end
    end
  end

  def represented_person_cant_be_also_a_participant
    if self.represented_person and self.audience and self.audience.participants and self.audience.participants.length > 0
      if self.audience.participants.any? { |p| p.person == self.represented_person }
        errors.add(:represented_person, "can't be also a participant")
      end
    end
  end

  def applicant_cant_represent_itself
    if self.represented_person == self.person
      errors.add(:person, "can't represent itself")
    end
  end

  def applicant_cant_be_the_obligee
    if self.audience and self.audience.obligee and self.audience.obligee.person == self.person
      errors.add(:person, "can't be the obligee")
    end
  end

  def represented_person_cant_be_the_obligee
    if self.audience and self.audience.obligee and self.audience.obligee.person == self.represented_person
      errors.add(:represented_person, "can't be the obligee")
    end
  end
end
