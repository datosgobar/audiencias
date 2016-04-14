class CreatesPeople < ActiveRecord::Migration
  
  def change

	  create_table :people do |t|

      t.string :person_id, index: true, null: false
      t.string :name, null: false
      t.string :surname, null: false
      t.integer :country
      t.string :telephone
      t.string :email
      t.timestamps

    end

  end
end
