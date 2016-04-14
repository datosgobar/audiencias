class Involved < ActiveRecord::Base

  has_one :person
  has_one :position
  has_one :represented
  has_one :company

  validates :person, presence: true

end
