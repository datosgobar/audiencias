class ChangesCountry < ActiveRecord::Migration

  def change
    remove_column :people, :country
    add_column :people, :country, :string
  end 
end 
