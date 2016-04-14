class CreatesParticipantsAndCompanies < ActiveRecord::Migration
  
  def change

	  create_table :participants do |t|

      t.references :involved, index: true, null: false
      t.references :audience, index: true, null: false
      t.timestamps

    end

    create_table :companies do |t|

      t.string :name, null: false
      t.timestamps

    end

  end
end
