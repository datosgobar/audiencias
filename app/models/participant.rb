class Participant < ActiveRecord::Base

  has_one :audience
  has_one :involved

  validates :audience, presence: true
  validates :involved, presence: true

end
