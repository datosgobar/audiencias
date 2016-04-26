class Position < ActiveRecord::Base

  has_one :obligee
  has_one :dependency

  validates :name, length: { minimum: 6 }

end
