class CreatesAudiences < ActiveRecord::Migration
  
  def change

	create_table :audiences do |t|

		t.references :obligee, index: true, null: false
		t.references :applicant, index: true, null: false
    t.datetime :application_date, null: false
		t.datetime :date
    t.datetime :publish_date
		t.integer :status
    t.string :summary
    t.integer :interest_invoked
    t.boolean :published
    t.string :place
		t.timestamps

    end

  end
end
