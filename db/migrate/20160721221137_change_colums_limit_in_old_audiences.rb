class ChangeColumsLimitInOldAudiences < ActiveRecord::Migration

  def up
    change_column :old_audiences, :sintesis_audiencia, :text
    change_column :old_audiences, :participante_audiencia, :text
  end

  def down
    change_column :old_audiences, :sintesis_audiencia, :string, :limit => 255
    change_column :old_audiences, :participante_audiencia, :string, :limit => 255
  end
end
