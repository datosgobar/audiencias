class ChangesCuilType < ActiveRecord::Migration

  def change
    remove_column :legal_entities, :cuil
    add_column :legal_entities, :cuil, :string  
  end 
end 


