class Audience < ActiveRecord::Base

  has_many :participants
  has_one :author

  validates :application_date, presence: true
  validates :date, presence: true
  validates :publish_date, presence: true
  validates :status, presence: true
  validates :summary, presence: true
  validates :interest_invoked, presence: true
  validates :published, presence: true
  validates :place, presence: true

end
