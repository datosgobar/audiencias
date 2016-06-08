class User < ActiveRecord::Base

	validates :name, presence: true
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

  def has_permission_for(thing)
    if role == 'superadmin'
      return true
    end

    if thing.is_a? Obligee
      obligee = thing
      return false unless obligee.active
      self.obligees.include?(obligee) or self.has_permission_for(obligee.dependency)

    elsif thing.is_a? Dependency

      dependency = thing
      return false unless dependency.active
      self.dependencies.include?(dependency) or dependency.is_sub_dependency_of(self.dependencies)

    elsif thing.is_a? User

      user = thing
      user_scope = user.dependencies + user.obligees
      for thing in user_scope 
        return true if self.has_permission_for(thing)
      end
      false

    elsif thing.is_a? Audience

      audience = thing
      not audience.deleted and not audience.published and self.has_permission_for(audience.obligee)

    else
      false
    end

  end


  AS_JSON_OPTIONS = {
    only: [:person_id, :id_type, :email, :id, :name, :telephone],
    include: { obligees: Obligee::AS_JSON_OPTIONS },
    methods: [:role]
  }
	def as_json(options={})
		super(AS_JSON_OPTIONS)
	end

  def role
    if is_superadmin
      'superadmin'
    elsif dependencies.length > 0
      'admin'
    elsif obligees.length > 0
      'operator'
    else
      'user'
    end
  end

	def self.find_by_document(id_type, person_id)
		where(id_type: id_type, person_id: person_id).first
	end

	def self.find_or_initialize(params)
		user = find_by_document(params[:id_type], params[:person_id])
    
    unless user
      user = new
      user.id_type = params[:id_type]
      user.person_id = params[:person_id]
      user.name = params[:name]
      user.email = params[:email]
      require 'securerandom'
      user.password = SecureRandom.urlsafe_base64(8)
    end

    user
	end

  def update_minor_attributes(new_attr)
    self.name = new_attr[:name] if new_attr[:name]
    self.email = new_attr[:email] if new_attr[:email]
  end
end
