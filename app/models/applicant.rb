class Applicant < ActiveRecord::Base
  has_one :audience
  belongs_to :person
  belongs_to :represented_person, foreign_key: 'represented_person_id', class_name: 'Person'
  belongs_to :represented_legal_entity, foreign_key: 'represented_legal_entity_id', class_name: 'LegalEntity'
  belongs_to :represented_state_organism, foreign_key: 'represented_state_organism_id', class_name: 'StateOrganism'
  belongs_to :represented_people_group, foreign_key: 'represented_people_group_id', class_name: 'PeopleGroup'

  AS_JSON_OPTIONS = {
    only: [ :id, :ocupation, :represented_person_ocupation, :absent ],
    include: {
      person: Person::AS_JSON_OPTIONS,
      represented_person: Person::AS_JSON_OPTIONS,
      represented_legal_entity: {},
      represented_state_organism: {},
      represented_people_group: {}
    }
  }
  def as_json(options={})
    super(AS_JSON_OPTIONS)
  end

  def update_minor_attributes(params)
    self.ocupation = params[:ocupation] if params.include?(:ocupation)
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
      self.represented_person_ocupation = params[:represented_person][:ocupation] if params[:represented_person].include?(:ocupation)
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
end
