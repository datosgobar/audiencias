class Dependency < ActiveRecord::Base

	belongs_to :obligee
	belongs_to :parent_dependency, foreign_key: 'parent_id', class_name: 'Dependency'

  has_many :admin_associations
  has_many :users, through: :admin_associations
  has_many :historic_obligees, foreign_key: 'dependency_id', class_name: 'Obligee'
  has_many :direct_sub_dependencies, foreign_key: 'parent_id', class_name: 'Dependency'
  
	validates :name, length: { minimum: 6 }

  def self.list_for_user(user)
    role = user.role
    return [] unless role == 'superadmin' or role == 'admin'
    
    if role == 'superadmin' 
      dependencies = where(active: true, parent_id: nil)
    else
      dependencies = user.dependencies
    end
    plain_dependencies = []
    tree_dependencies = []
    dependencies.each do |dependency|
      full_branch = dependency.as_json_with_sub_dependencies
      plain_dependencies << full_branch
      tree_dependencies << full_branch
      plain_dependencies.concat dependency.all_sub_dependencies
    end
    { plain: plain_dependencies, tree: tree_dependencies }
  end

  def all_sub_dependencies
    dependencies = []
    self.direct_sub_dependencies.each do |sub_dependency|
      dependencies << sub_dependency.as_json_with_sub_dependencies
      dependencies.concat sub_dependency.all_sub_dependencies
    end
    dependencies
  end

  def as_json(options={})
    json = super({
      only: [:id, :name, :active, :parent_id],
      include: { 
        users: User::AS_JSON_OPTIONS,
        obligee: Obligee::AS_JSON_OPTIONS
      }
    })
    json['obligee'] = nil unless json.key?('obligee')
    json
  end

  def as_json_with_sub_dependencies
    json = self.as_json
    json[:children] = []
    self.direct_sub_dependencies.each do |dependency|
      json[:children] << dependency.as_json_with_sub_dependencies
    end
    json
  end

  def is_sub_dependency_of(dependencies)
    is_sub_dependency = false
    dependencies.each do |dependency|
      if self.id == dependency.id or self.is_sub_dependency_of(dependency.direct_sub_dependencies)
        is_sub_dependency = true
        break
      end
    end
    is_sub_dependency
  end

  def update_minor_attributes(new_attr)
    self.name = new_attr[:name] if new_attr[:name]
  end

end
