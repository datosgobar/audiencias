class LegalEntity < ActiveRecord::Base

  def update_minor_attributes(params)
    self.country = params[:country] if params.include?(:country)
    self.name = params[:name] if params.include?(:name)
    self.cuit = params[:cuit] if params.include?(:cuit)
    self.email = params[:email] if params.include?(:email)
    self.telephone = params[:telephone] if params.include?(:telephone)
  end

end