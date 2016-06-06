class CollapsePeopleSurnameIntoName < ActiveRecord::Migration

  def up
    Person.all.each do |person|
      person.name = "#{person.surname} #{person.name}"
      person.save
    end
    remove_column :people, :surname
  end 
end 
