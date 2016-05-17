class Obligee < ActiveRecord::Base

	belongs_to :person
	belongs_to :dependency

  has_many :operator_associations
  has_many :users, through: :operator_associations

	validates :person, presence: true
	validates :dependency, presence: true
	validates :position, presence: true


  AS_JSON_OPTIONS = {
    only: [:id, :active, :position],
    include: [{ person: Person::MINIMAL_JSON_OPTIONS }, { users: { only: [:id] } }]
  }
  def as_json(options={})
    super(AS_JSON_OPTIONS)
  end

  def update_minor_attributes(new_attr)
    self.position = new_attr[:position] if new_attr[:position]
  end
end
