class CreatesDependencies < ActiveRecord::Migration
  
  def change

	create_table :dependencies do |t|

		t.string :name, null: false
		t.references :obligee, index: true, null: false
		t.references :position, index: true, null: false
		t.references :parent, index: true
		t.boolean :active, default: true
		t.timestamps

    end

  end
end
