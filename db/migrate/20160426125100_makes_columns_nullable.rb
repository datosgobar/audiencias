class MakesColumnsNullable < ActiveRecord::Migration
  
  def up

    change_column :positions, :dependency_id, :int, :null => true
    change_column :positions, :obligee_id, :int, :null => true
    change_column :dependencies, :position_id, :int, :null => true
    change_column :dependencies, :obligee_id, :int, :null => true

  end

  def down 

    change_column :positions, :dependency_id, :int, :null => false
    change_column :positions, :obligee_id, :int, :null => false
    change_column :dependencies, :position_id, :int, :null => false
    change_column :dependencies, :obligee_id, :int, :null => false

  end
end


