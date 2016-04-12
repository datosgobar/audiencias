class CreateUsers < ActiveRecord::Migration
  
  def change

    create_table :users do |t|
    
      t.integer :dni, null: false, unique: true
      t.string :name, null: false
      t.string :surname, null: false
      t.string :email, null: false, unique: true
      t.string :telephone
      t.string :password_digest
      t.timestamps

    end

  end
end
