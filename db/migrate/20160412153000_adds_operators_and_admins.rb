class AddsOperatorsAndAdmins < ActiveRecord::Migration
  
  def change

	create_table :admin_associations do |t|

		t.references :user, index: true, null: false
		t.references :dependency, index: true, null: false
		t.timestamps

    end

    create_table :operator_associations do |t|

		t.references :user, index: true, null: false
		t.references :obligee, index: true, null: false
		t.timestamps

    end

  end
end
