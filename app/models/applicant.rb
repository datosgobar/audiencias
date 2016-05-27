class Applicant < ActiveRecord::Base
  has_one :audience
  belongs_to :represented_person, foreign_key: 'represented_person_id', class_name: 'Person'
  belongs_to :represented_legal_entity, foreign_key: 'represented_legal_entity_id', class_name: 'LegalEntity'
  belongs_to :represented_state_organism, foreign_key: 'represented_state_organism_id', class_name: 'StateOrganism'
  belongs_to :represented_people_group, foreign_key: 'represented_people_group_id', class_name: 'PeopĺeGroup'

  AS_JSON_OPTIONS = {
    only: [ :ocupation, :represented_person_ocupation ],
    include: {
      represented_person: Person::AS_JSON_OPTIONS,
      represented_legal_entity: {},
      represented_state_organism: {},
      represented_people_group: {}
    }
  }
  def as_json(options={})
    super(AS_JSON_OPTIONS)
  end
end
