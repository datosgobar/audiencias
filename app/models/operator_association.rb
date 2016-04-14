class OperatorAssociation < ActiveRecord::Base
	has_one :user
	has_one :obligee

	validates :user, presence: true, uniqueness: { scope: :obligee }
  validates :obligee, presence: true

end
