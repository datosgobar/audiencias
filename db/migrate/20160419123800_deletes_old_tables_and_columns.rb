class DeletesOldTablesAndColumns < ActiveRecord::Migration
  
  def change
    drop_table :involved
    remove_column :audiences, :obligee_id
    remove_column :audiences, :applicant_id
    remove_column :participants, :involved_id
  end
end
