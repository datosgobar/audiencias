class AdminAssociation < ActiveRecord::Base
	has_one :user
	has_one :dependency
end
