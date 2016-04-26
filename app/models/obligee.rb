class Obligee < ActiveRecord::Base

	has_one :person
	has_one :dependency
	has_one :position

  has_many :operator_associations
  has_many :users, through: :operator_associations

	validates :person, presence: true
	validates :dependency, presence: true
	validates :position, presence: true

end
