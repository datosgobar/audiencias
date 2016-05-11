class Dependency < ActiveRecord::Base

	has_one :obligee
	has_one :parent_dependency
	has_one :position

  has_many :admin_associations
  has_many :users, through: :admin_associations
  
	validates :name, length: { minimum: 6 }

  def self.for_user(user)
    # TODO: filtrar el arbol segun permisos de usuario
    active_dependencies = where(active: true).as_json
    plain_dependencies = active_dependencies.clone

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

    {
      tree: active_dependencies.select { |d| !d['parent_id'] },
      plain: plain_dependencies
    }
  end

  def as_json(options={})
    super(include: { users: User::AS_JSON_OPTIONS })
  end

end
