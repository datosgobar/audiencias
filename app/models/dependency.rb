class Dependency < ActiveRecord::Base

	has_one :obligee
	has_one :parent_dependency
	has_one :position

  has_many :admin_associations
  has_many :users, through: :admin_associations
  
	validates :name, length: { minimum: 6 }

  def self.tree 
    active_dependencies = where(active: true).as_json
    
    active_dependencies.each do |dependency|
      if dependency['parent_id']
        parent = active_dependencies.find { |parent| parent['id'] == dependency['parent_id'] }
        if parent 
          unless parent['children']
            parent['children'] = []
          end
          parent['children'] << dependency
        end
      end
    end

    active_dependencies.select { |d| !d['parent_id'] }
  end

end
