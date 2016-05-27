class Audience < ActiveRecord::Base

  belongs_to :author, foreign_key: 'author_id', class_name: 'User'
  belongs_to :obligee
  belongs_to :applicant
  has_many :participants

  validates :author, presence: true
  validates :obligee, presence: true

  AS_JSON_OPTIONS =  {
    only: [ :date, :publish_date, :summary, :interest_invoked, 
      :published, :place, :created_at, :lat, :lng, :id ],
    include: { 
      author: User::AS_JSON_OPTIONS,
      applicant: Applicant::AS_JSON_OPTIONS,
      obligee: Obligee::AS_JSON_OPTIONS 
    }
  }
  def as_json(options={})
    super(AS_JSON_OPTIONS)
  end
end
