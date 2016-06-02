class RenamesTypoOnCuitColumn < ActiveRecord::Migration

  def change
    rename_column :legal_entities, :cuil, :cuit
  end 
end 