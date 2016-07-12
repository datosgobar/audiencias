class Person < ActiveRecord::Base

  validates :name, presence: true, length: { maximum: 200 }
  validates :person_id, presence: true, length: { maximum: 20 }
  validates :id_type, presence: true, length: { maximum: 20 }, allow_blank: true
  validates :country, presence: true
  validates_inclusion_of :country, :in => GLOBALS::COUNTRIES
  validates :email, format: { with: GLOBALS::EMAIL_REGEX }, length: { maximum: 100 }, allow_blank: true
  validates :telephone, length: { maximum: 20 }, allow_blank: true
  has_many :obligees
  has_many :applicants
  after_initialize :set_default_country

  def self.find_by_document(id_type, person_id)
    where(id_type: id_type, person_id: person_id).first
  end

  def self.find_or_initialize(params)
    person = find_by_document(params[:id_type], params[:person_id])
    
    unless person
      person = new
      person.id_type = params[:id_type]
      person.person_id = params[:person_id]
      person.update_minor_attributes(params)
    end

    person
  end

  def has_active_obligee
    active_obligee = false
    obligees.each do |obligee|
      if obligee.active 
        active_obligee = true 
        break
      end
    end
    active_obligee
  end

  AS_JSON_OPTIONS = {
    only: [:country, :email, :id, :id_type, :name, :person_id, :telephone]
  }
  AS_PUBLIC_JSON_OPTIONS = {
    only: [:country, :id, :id_type, :name, :person_id]
  }
  MINIMAL_JSON_OPTIONS = {
    only: [:email, :id, :id_type, :name, :person_id]
  }
  def as_json(options={})
    if options[:minimal]
      super({ only: [:id, :name] })
    else
      super(AS_JSON_OPTIONS)
    end
  end

  def update_minor_attributes(new_attr)
    self.name = new_attr[:name] if new_attr.include? :name
    self.telephone = new_attr[:telephone] if new_attr.include? :telephone
    self.email = new_attr[:email] if new_attr.include? :email and new_attr[:email].length > 0
    self.country = new_attr[:country] if new_attr.include? :country
  end

  private

  def set_default_country
    self.country ||= 'Argentina'
  end
end
