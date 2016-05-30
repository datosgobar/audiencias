class Participant < ActiveRecord::Base

  belongs_to :audience
  belongs_to :person

  validates :audience, presence: true
  validates :person, presence: true
  validates :ocupation, presence: true

  AS_JSON_OPTIONS = {
    only: [:ocupation],
    include: {
      person: Person::AS_JSON_OPTIONS
    }
  }

end
