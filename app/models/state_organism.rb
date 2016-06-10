class StateOrganism < ActiveRecord::Base

  validates_inclusion_of :country, :in => GLOBALS::COUNTRY, allow_blank: true
  validates :name, length: { maximum: 200 }, presence: true

  def update_minor_attributes(params)
    self.country = params[:country] if params.include?(:country)
    self.name = params[:name].mb_chars.upcase if params.include?(:name)
  end
end