class CreatesPositions < ActiveRecord::Migration
  
  def change

	create_table :positions do |t|

		t.string :name, null: false
		t.references :obligee, index: true, null: false
		t.references :dependency, index: true, null: false
		t.boolean :active, default: true
		t.timestamps

    end

  end
end
