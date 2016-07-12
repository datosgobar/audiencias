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
    include: [
      { person: Person::MINIMAL_JSON_OPTIONS }, 
      { users: { only: [:id] } }, 
      { dependency: { only: [:name, :active]} }
    ]
  }
  AS_PUBLIC_JSON_OPTIONS = {
    only: [:id, :active, :position],
    include: [
      { person: Person::AS_PUBLIC_JSON_OPTIONS },
      { dependency: { only: [:name, :active]} }
    ]
  }
  def as_json(options={})
    super(AS_JSON_OPTIONS)
  end

  def update_minor_attributes(new_attr)
    self.position = new_attr[:position] if new_attr[:position]
  end

  def search_audiences(query)
    Audience.operator_search(query, self.person.id).records
  end

  def all_audiences
    proper_audiences = audiences.where(deleted: false)
    as_applicant_audiences = Audience.joins(:applicant).where('person_id = ?', person.id)
    as_participant_audiences = Audience.joins(:participants).where('person_id = ?', person.id)
    (proper_audiences | as_applicant_audiences | as_participant_audiences).sort_by(&:created_at).reverse

    Audience
      .where(deleted: false)
      .joins('LEFT OUTER JOIN applicants ON applicants.id = audiences.applicant_id')
      .joins('LEFT JOIN participants ON participants.audience_id = audiences.id')
      .where('obligee_id = ? OR applicants.person_id = ? OR participants.person_id = ?', self.id, person_id, person_id).distinct
    
  end
end
