class Audience < ActiveRecord::Base

  has_one :obligee
  has_one :applicant

end
