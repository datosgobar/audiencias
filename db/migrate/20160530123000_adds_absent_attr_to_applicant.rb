class AddsAbsentAttrToApplicant < ActiveRecord::Migration

  def change
    add_column :applicants, :absent, :boolean
  end 
end 
