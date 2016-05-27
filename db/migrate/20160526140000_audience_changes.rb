class AudienceChanges < ActiveRecord::Migration

  def change
    drop_table :companies

    add_column :audiences, :obligee_id, :integer
    add_index :audiences, :obligee_id
    add_column :audiences, :applicant_id, :integer
    add_index :audiences, :applicant_id
    add_column :audiences, :lat, :decimal, {:precision=>10, :scale=>6}
    add_column :audiences, :lng, :decimal, {:precision=>10, :scale=>6}
    add_column :audiences, :motif, :string
    remove_column :audiences, :application_date
    remove_column :audiences, :status

    remove_column :participants, :dependency_id
    remove_column :participants, :represented_id
    remove_column :participants, :company_id
    remove_column :participants, :applicant
    remove_column :participants, :requested
    add_column :participants, :ocupation, :string

    create_table :legan_entities do |t|
      t.string :country
      t.integer :cuil
      t.string :name
      t.string :email
      t.string :telephone
      t.timestamps
    end

    create_table :state_organisms do |t|
      t.string :country
      t.string :name
      t.timestamps
    end

    create_table :people_groups do |t|
      t.string :country
      t.string :name
      t.string :email
      t.string :telephone
      t.string :description
      t.timestamps
    end

    create_table :applicants do |t|
      t.string :ocupation
      t.references :audience
      t.references :represented_person
      t.string :represented_person_ocupation
      t.references :represented_legal_entity
      t.references :represented_state_organism
      t.references :represented_people_group
      t.timestamps
    end 

  end 
end 
