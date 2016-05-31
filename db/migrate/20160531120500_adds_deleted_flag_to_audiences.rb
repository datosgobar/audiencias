class AddsDeletedFlagToAudiences < ActiveRecord::Migration

  def change
    add_column :audiences, :deleted, :boolean, default: false
    add_column :audiences, :deleted_at, :date
  end 
end 
