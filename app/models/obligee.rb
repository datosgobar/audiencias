class Obligee < ActiveRecord::Base

	belongs_to :person
	belongs_to :dependency

  has_many :operator_associations
  has_many :users, through: :operator_associations
  has_many :audiences

	validates :person, presence: true
	validates :dependency, presence: true
	validates :position, presence: true, length: { maximum: 200 }

  AS_JSON_OPTIONS = {
    only: [:id, :active, :position],
    include: [{ person: Person::MINIMAL_JSON_OPTIONS }, { users: { only: [:id] } }]
  }
  AS_PUBLIC_JSON_OPTIONS = {
    only: [:id, :active, :position],
    include: [{ person: Person::AS_PUBLIC_JSON_OPTIONS }]
  }
  def as_json(options={})
    super(AS_JSON_OPTIONS)
  end

  def update_minor_attributes(new_attr)
    self.position = new_attr[:position] if new_attr[:position]
  end

  def search_audiences(query)
    Audience.operator_search(query, self.person.id).records.all
  end

  def all_audiences
    proper_audiences = audiences.where(deleted: false)
    as_applicant_audiences = Audience.joins(:applicant).where('person_id = ?', person.id)
    as_participant_audiences = Audience.joins(:participants).where('person_id = ?', person.id)
    (proper_audiences | as_applicant_audiences | as_participant_audiences).sort_by(&:created_at).reverse
  end
end
