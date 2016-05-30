class ChangeInvokedInterest < ActiveRecord::Migration

  def change

    remove_column :audiences, :interest_invoked
    add_column :audiences, :interest_invoked, :string

  end 
end 
