class User < ActiveRecord::Base

	validates :name, presence: true
	validates :surname, presence: true
	validates :email, format: { with: GLOBALS::EMAIL_REGEX }, uniqueness: { case_sensitive: false }
	validates :dni, presence: true, uniqueness: true
	validates :password, length: { minimum: 6 }, allow_nil: true
	validates :auth_token, uniqueness: true

	has_secure_password
	before_create { generate_token(:auth_token) }
	before_save { self.email = email.downcase }

	has_many :admin_associations
	has_many :dependencies, through: :admin_associations
	has_many :operator_associations
	has_many :obligees, through: :operator_associations

	def generate_token(column)
		begin
			self[column] = SecureRandom.urlsafe_base64
		end while User.exists?(column => self[column])
	end

	def send_password_reset
		generate_token(:password_reset_token)
		self.password_reset_sent_at = Time.zone.now
		save!
		UserMailer.password_reset(self).deliver
	end

	def as_json(options={})
		super({
			only: [:dni, :email, :id, :is_superadmin, :name, :surname, :telephone]
		})
	end

end
