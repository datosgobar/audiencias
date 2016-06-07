class Participant < ActiveRecord::Base

  belongs_to :audience
  belongs_to :person

  validates :audience, presence: true
  validates :person, presence: true, uniqueness: { scope: :audience }

  AS_JSON_OPTIONS = {
    only: [:id, :ocupation],
    include: {
      person: Person::AS_JSON_OPTIONS
    }
  }
  def as_json(options={})
    super(AS_JSON_OPTIONS)
  end

  def update_minor_attributes(params)
    self.ocupation = params[:ocupation].mb_chars.upcase if params[:ocupation]
    if params[:person]
      self.person = Person.find_or_initialize(params[:person])
      self.person.update_minor_attributes(params[:person])
      self.person.save
    end
  end

  def publish_validations
    if self.audience and self.person and self.ocupation and self.ocupation.length > 0
      'valid'
    else
      'incomplete'
    end
  end
end
