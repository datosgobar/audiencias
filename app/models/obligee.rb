class Obligee < ActiveRecord::Base

	has_one :person
	has_one :dependency
	has_one :position

	validates :person, presence: true
	validates :dependency, presence: true
	validates :position, presence: true

end
