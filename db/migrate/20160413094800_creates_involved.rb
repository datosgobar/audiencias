class CreatesInvolved < ActiveRecord::Migration
  
  def change

	create_table :involved do |t|

		t.references :person, index: true, null: false
		t.references :position, index: true
    t.references :represented, index: true
    t.references :company, index: true
		t.timestamps

    end

  end
end
