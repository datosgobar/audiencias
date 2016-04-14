class Position < ActiveRecord::Base

  has_one :obligee
  has_one :dependency

  validates :obligee, presence: true
  validates :dependency, presence: true

end