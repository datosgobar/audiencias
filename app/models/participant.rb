class Participant < ActiveRecord::Base

  belongs_to :audience
  belongs_to :person

  validates :audience, presence: true
  validates :person, presence: true, uniqueness: { scope: :audience }
  validates :ocupation, presence: true

  AS_JSON_OPTIONS = {
    only: [:id, :ocupation],
    include: {
      person: Person::AS_JSON_OPTIONS
    }
  }
  def as_json(options={})
    super(AS_JSON_OPTIONS)
  end

end
