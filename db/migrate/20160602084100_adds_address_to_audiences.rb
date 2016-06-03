class AddsAddressToAudiences < ActiveRecord::Migration

  def change
    add_column :audiences, :address, :string
  end 
end 
