class ChangesPosition < ActiveRecord::Migration

  def change
    drop_table :positions
    remove_column :participants, :position_id
    remove_column :obligees, :position_id
    remove_column :dependencies, :position_id
    add_column :obligees, :position, :string
  end 
end 
