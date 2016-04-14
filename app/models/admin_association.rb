class AdminAssociation < ActiveRecord::Base
	has_one :user
	has_one :dependency

	validates :user, presence: true, uniqueness: { scope: :dependency }
	validates :dependency, presence: true

end
