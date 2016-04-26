class Dependency < ActiveRecord::Base

	has_one :obligee
	has_one :parent_dependency
	has_one :position

  has_many :admin_associations
  has_many :users, through: :admin_associations
  
	validates :name, length: { minimum: 6 }

end
