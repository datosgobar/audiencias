class User < ActiveRecord::Base

	validates :name, presence: true
	validates :surname, presence: true
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
	validates :dni, presence: true, uniqueness: true
	validates :password, length: { minimum: 6 }

	before_save { self.email = email.downcase }
	has_secure_password
end
