class AddsFieldsToOldAudiences < ActiveRecord::Migration

  def change
    add_column :old_audiences, :es_persona_juridica, :boolean
    add_column :old_audiences, :derivada_a_apellido, :string
    add_column :old_audiences, :derivada_a_nombre, :string
    add_column :old_audiences, :derivada_a_cargo, :string
  end 
end 
