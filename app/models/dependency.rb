class Dependency < ActiveRecord::Base

	has_one :obligee
	has_one :parent_dependency
	has_one :position

	validates :obligee, presence: true
  validates :position, presence: true
	validates :name, length: { minimum: 6 }

end
