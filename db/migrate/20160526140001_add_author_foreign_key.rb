class AddAuthorForeignKey < ActiveRecord::Migration

  def change

    add_column :audiences, :author_id, :integer
    add_index :audiences, :author_id

  end 
end 
