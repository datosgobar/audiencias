class Participant < ActiveRecord::Base

  has_one :audience
  has_one :dependency
  has_one :person
  has_one :represented
  has_one :company

  validates :audience, presence: true

end
