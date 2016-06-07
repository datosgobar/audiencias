class PeopleGroup < ActiveRecord::Base

  def update_minor_attributes(params)
    self.country = params[:country] if params.include?(:country)
    self.name = params[:name].mb_chars.upcase if params.include?(:name)
    self.email = params[:email] if params.include?(:email)
    self.telephone = params[:telephone] if params.include?(:telephone)
    self.description = params[:description] if params.include?(:description)
  end
end