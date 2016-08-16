require 'elasticsearch/model'

class OldAudience < ActiveRecord::Base

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  include OldAudienceSearchMethods
  include OldAudienceDownloadMethods
  self.per_page = 15


  def as_json(options={})
    options[:except] ||= [:created_at, :updated_at]
    super(options)
  end

end