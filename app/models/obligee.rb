class Obligee < ActiveRecord::Base

	belongs_to :person
	belongs_to :dependency

  has_many :operator_associations
  has_many :users, through: :operator_associations

	validates :person, presence: true
	validates :dependency, presence: true
	validates :position, presence: true


  AS_JSON_OPTIONS = {
    only: [:active],
    include: [{ person: Person::AS_JSON_OPTIONS }, { users: User::AS_JSON_OPTIONS }]
  }
  def as_json(options={})
    super(AS_JSON_OPTIONS)
  end
end
