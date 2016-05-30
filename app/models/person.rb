class Person < ActiveRecord::Base

  validates :name, presence: true
  validates :surname, presence: true
  validates :person_id, presence: true
  validates :id_type, presence: true
  validates :country, presence: true
  validates :email, format: { with: GLOBALS::EMAIL_REGEX }
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
      person.name = params[:name]
      person.surname = params[:surname]
      person.email = params[:email]
      person.country = params[:country]
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
    only: [:country, :email, :id, :id_type, :name, :person_id, :surname, :telephone]
  }
  MINIMAL_JSON_OPTIONS = {
    only: [:email, :id, :id_type, :name, :person_id, :surname]
  }
  def as_json(options={})
    super(AS_JSON_OPTIONS)
  end

  def update_minor_attributes(new_attr)
    self.name = new_attr[:name] if new_attr[:name]
    self.surname = new_attr[:surname] if new_attr[:surname]
    self.telephone = new_attr[:telephone] if new_attr[:telephone]
    self.email = new_attr[:email] if new_attr[:email]
    self.country = new_attr[:country] if new_attr[:country]
  end

  private

  def set_default_country
    self.country ||= 'Argentina'
  end
end
