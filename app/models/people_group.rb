class PeopleGroup < ActiveRecord::Base

  validates_inclusion_of :country, :in => GLOBALS::COUNTRIES, allow_blank: true
  validates :name, length: { maximum: 200 }, presence: true
  validates :email, format: { with: GLOBALS::EMAIL_REGEX }, length: { maximum: 100 }, allow_blank: true
  validates :telephone, length: { maximum: 20 }, allow_blank: true
  validates :description, length: { maximum: 200 }, allow_blank: true

  def update_minor_attributes(params)
    self.country = params[:country] if params.include?(:country)
    self.name = params[:name].mb_chars.upcase if params.include?(:name)
    self.email = params[:email] if params.include?(:email)
    self.telephone = params[:telephone] if params.include?(:telephone)
    self.description = params[:description] if params.include?(:description)
  end
end