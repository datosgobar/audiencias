class RenamesTypoOnTableName < ActiveRecord::Migration

  def change
    rename_table :legan_entities, :legal_entities
  end 
end 