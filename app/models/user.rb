class User < ActiveRecord::Base

	validates :name, presence: true
	validates :surname, presence: true
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
	validates :dni, presence: true, uniqueness: true
	validates :password, length: { minimum: 6 }, allow_nil: true
	validates :auth_token, uniqueness: true

	has_secure_password
	before_create { generate_token(:auth_token) }
	before_save { self.email = email.downcase }

	def generate_token(column)
		begin
			self[column] = SecureRandom.urlsafe_base64
		end while User.exists?(column => self[column])
	end

end
