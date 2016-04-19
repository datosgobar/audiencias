class AddsNewParticipantsColumnsAndPeoplesIdType < ActiveRecord::Migration
  
  def change
    add_column :people, :id_type, :string

    add_column :participants, :position_id, :integer
    add_index :participants, :position_id

    add_column :participants, :dependency_id, :integer
    add_index :participants, :dependency_id

    add_column :participants, :person_id, :integer
    add_index :participants, :person_id

    add_column :participants, :represented_id, :integer
    add_index :participants, :represented_id

    add_column :participants, :company_id, :integer
    add_index :participants, :company_id

    add_column :participants, :applicant, :boolean, default: false
    add_column :participants, :requested, :boolean, default: false
  end
end
