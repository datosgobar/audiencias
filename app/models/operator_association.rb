class OperatorAssociation < ActiveRecord::Base
	has_one :user
	has_one :obligee
end
