class Dependency < ActiveRecord::Base

	belongs_to :obligee
	belongs_to :parent_dependency, foreign_key: 'parent_id', class_name: 'Dependency'

  has_many :admin_associations
  has_many :users, through: :admin_associations
  has_many :historic_obligees, foreign_key: 'dependency_id', class_name: 'Obligee'
  
	validates :name, length: { minimum: 6 }

  def self.list_for_user(user)
    if user.role == 'superadmin' 
      list_all_active
    elsif user.role == 'admin'
      list_administred_by(user)
    else
      []
    end
    
  end

  def self.list_all_active
    active_dependencies = where(active: true).as_json
    list = { plain: active_dependencies.clone }
    trees = all_trees(active_dependencies)
    list[:tree] = trees.select { |d| !d['parent_id'] }
    list
  end

  def self.list_administred_by(user)
    active_dependencies = where(active: true).as_json
    list = { plain: active_dependencies.clone }
    trees = all_trees(active_dependencies)
    user_dependencies = user.dependencies.collect(&:id)
    list[:tree] = trees.select { |d| user_dependencies.include?(d.id) }
    list
  end

  def self.all_trees(dependencies)
    dependencies.each do |dependency|
      if dependency['parent_id']
        parent = dependencies.find { |parent| parent['id'] == dependency['parent_id'] }
        if parent 
          unless parent['children']
            parent['children'] = []
          end
          parent['children'] << dependency
        end
      end
    end
    dependencies
  end

  def as_json(options={})
    super({
      only: [:id, :name, :active, :parent_id],
      include: { 
        users: User::AS_JSON_OPTIONS,
        obligee: Obligee::AS_JSON_OPTIONS
      }
    })
  end

end
