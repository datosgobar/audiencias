class Position < ActiveRecord::Base

  validates :name, presence: true
  validates :surname, presence: true
  validates :person_id, presence: true
  validates :id_type, presence: true
  validates :country, presence: true
  validates :email, format: { with: EMAIL_REGEX }

end
