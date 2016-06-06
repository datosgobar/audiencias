class CollapseUsersSurnameIntoName < ActiveRecord::Migration

  def up
    User.all.each do |user|
      user.name = "#{user.surname} #{user.name}"
      user.save
    end
    remove_column :users, :surname
  end 
end 
