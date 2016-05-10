class RenamesIdColumn < ActiveRecord::Migration

  def change
    rename_column :users, :dni, :person_id
  end 
end 
