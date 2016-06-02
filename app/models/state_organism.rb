class StateOrganism < ActiveRecord::Base

  def update_minor_attributes(params)
    self.country = params[:country] if params.include?(:country)
    self.name = params[:name] if params.include?(:name)
  end
end