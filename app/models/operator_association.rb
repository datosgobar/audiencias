class OperatorAssociation < ActiveRecord::Base
	belongs_to :user
	belongs_to :obligee

	validates :user, presence: true, uniqueness: { scope: :obligee }
  validates :obligee, presence: true

end
