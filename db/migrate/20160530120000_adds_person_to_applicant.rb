class AddsPersonToApplicant < ActiveRecord::Migration

  def change
    add_column :applicants, :person_id, :integer
    add_index :applicants, :person_id

  end 
end 
