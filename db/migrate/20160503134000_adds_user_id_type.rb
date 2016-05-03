class AddsUserIdType < ActiveRecord::Migration

  def change
    add_column :users, :id_type, :string
  end 
end 
