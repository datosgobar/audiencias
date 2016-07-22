class ChangeColumLiminginAudience < ActiveRecord::Migration
  def up
    change_column :audiences, :summary, :text
  end

  def down
    change_column :audiences, :summary, :string, :limit => 255
  end
end
