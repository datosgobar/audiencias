class CreatesObligees < ActiveRecord::Migration
  
  def change

	create_table :obligees do |t|

		t.references :person, index: true, null: false
		t.references :dependency, index: true, null: false
		t.references :position, index: true, null: false
		t.boolean :active, default: true
		t.timestamps

    end

  end
end
