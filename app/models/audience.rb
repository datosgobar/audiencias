class Audience < ActiveRecord::Base

  belongs_to :author, foreign_key: 'author_id', class_name: 'User'
  belongs_to :obligee
  belongs_to :applicant
  has_many :participants

  validates :author, presence: true
  validates :obligee, presence: true

  AS_JSON_OPTIONS =  {
    only: [ :date, :publish_date, :summary, :interest_invoked, :address,
      :published, :place, :created_at, :lat, :lng, :id, :motif ],
    include: { 
      author: User::AS_JSON_OPTIONS,
      applicant: Applicant::AS_JSON_OPTIONS,
      obligee: Obligee::AS_JSON_OPTIONS,
      participants: Participant::AS_JSON_OPTIONS
    },
    methods: [ :state ]
  }
  def as_json(options={})
    super(AS_JSON_OPTIONS)
  end

  def update_minor_attributes(params)
    self.date = params[:date] if params[:date]
    self.summary = params[:summary] if params[:summary]
    self.interest_invoked = params[:interest_invoked] if params[:interest_invoked]
    self.place = params[:place] if params[:place]
    self.lat = params[:lat] if params[:lat]
    self.lng = params[:lng] if params[:lng]
    self.address = params[:address] if params[:address]
    self.motif = params[:motif] if params[:motif]

    if params[:applicant]
      self.applicant = Applicant.new unless self.applicant
      self.applicant.update_minor_attributes(params[:applicant])
      self.applicant.save
    end

    if params[:participant]
      id_type = params[:participant][:person][:id_type]
      person_id = params[:participant][:person][:person_id]
      participant = self.participants.find { |p| p.person.id_type == id_type and p.person.person_id == person_id }
      participant = Participant.new(audience: self) unless participant
      participant.update_minor_attributes(params[:participant])
      participant.save
      self.participants << participant unless self.participants.include?(participant)
    end
  end

  def state
    valid = (self.date && self.date < DateTime.now && self.summary && self.summary.length > 0 && 
      self.interest_invoked && ['particular', 'difuso', 'colectivo'].include?(self.interest_invoked) && 
      self.place && self.place.length > 0 && self.author && self.obligee && self.motif && self.motif.length > 0)
    if valid 
      'valid'
    else
      'incomplete'
    end
  end
end
