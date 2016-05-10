class User < ActiveRecord::Base

	validates :name, presence: true
	validates :surname, presence: true
	validates :email, format: { with: GLOBALS::EMAIL_REGEX }, uniqueness: { case_sensitive: false }
	validates_inclusion_of :id_type, :in => %w(dni lc le)
	validates :person_id, presence: true, uniqueness: true
	validates_numericality_of :person_id, only_integer: true, greater_than: 0
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
		UserMailer.password_reset(self).deliver_now
	end

	def has_any_permit
		is_superadmin or dependencies.length > 0 or obligees.length > 0
	end

	def as_json(options={})
		json = super({
			only: [:person_id, :id_type, :email, :id, :name, :surname, :telephone]
		})
		if is_superadmin
			json[:role] = 'superadmin'
		elsif dependencies.length > 0
			json[:role] = 'admin'
		elsif obligees.length > 0
			json[:role] = 'operator'
		end
		json
	end

	def self.find_by_document(id_type, person_id)
		where(id_type: id_type, person_id: person_id).first
	end
end
