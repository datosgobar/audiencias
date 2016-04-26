class AdminAssociation < ActiveRecord::Base
	belongs_to :user
	belongs_to :dependency

	validates :user, presence: true, uniqueness: { scope: :dependency }
	validates :dependency, presence: true

end
