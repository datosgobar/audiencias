class Participant < ActiveRecord::Base

  belongs_to :audience
  belongs_to :person

  validates :audience, presence: true
  validates :person, presence: true, uniqueness: { scope: :audience }
  validates :ocupation, length: { maximum: 200 }, allow_blank: true
  validate :cant_be_the_applicant
  validate :cant_be_the_represented_person
  validate :cant_be_the_obligee

  AS_JSON_OPTIONS = {
    only: [:id, :ocupation],
    include: {
      person: Person::AS_JSON_OPTIONS
    }
  }
  AS_PUBLIC_JSON_OPTIONS = {
    only: [:id, :ocupation],
    include: {
      person: Person::AS_PUBLIC_JSON_OPTIONS
    }
  }
  def as_json(options={})
    if options[:spanish]
      {
        'id' => person.person_id,
        'nombre' => person.name,
        'pais' => person.country,
        'ocupacion' => ocupation
      }
    else
      super(AS_JSON_OPTIONS)
    end
  end

  def update_minor_attributes(params)
    self.ocupation = params[:ocupation].mb_chars if params[:ocupation]
    if params[:person]
      self.person = Person.find_or_initialize(params[:person])
      self.person.update_minor_attributes(params[:person])
      self.person.save
    end
  end

  def publish_validations
    if self.audience and self.person
      'valid'
    else
      'incomplete'
    end
  end

  def cant_be_the_applicant
    if self.audience.applicant and self.audience.applicant.person == self.person 
      errors.add(:person, "can't be the applicant")
    end 
  end

  def cant_be_the_represented_person
    if self.audience.applicant and self.audience.applicant.represented_person == self.person
      errors.add(:person, "can't be the represented person")
    end
  end

  def cant_be_the_obligee
    if self.audience.obligee and self.audience.obligee.person == self.person 
      errors.add(:person, "can't be the obligee")
    end 
  end
end
