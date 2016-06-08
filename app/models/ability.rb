class Ability
  include CanCan::Ability

  def initialize(user, params)
    
    if user 
      role = user.role
      can :manage, UtilsController

      if role == 'superadmin'
        can :manage, ManagementController
        can :manage, OperatorsController
      else
        can :dependency_list, ManagementController 
        can :user_list, ManagementController 
        can :admin_landing, ManagementController if role == 'admin'

        dependency = load_dependency(params)
        if user.has_permission_for(dependency)
          can :new_admin, ManagementController 
          can :new_obligee, ManagementController
          can :new_operator, ManagementController
          can :remove_admin, ManagementController
          can :remove_obligee, ManagementController
          can :remove_operator, ManagementController
          can :update_obligee, ManagementController
          can :update_dependency, ManagementController
          can :remove_dependency, ManagementController
        end

        another_user = load_user(params)
        if user.has_permission_for(another_user)
          can :update_user, ManagementController
        end

        parent_dependency = load_parent_dependency(params)
        if user.has_permission_for(parent_dependency)
          can :new_dependency, ManagementController
        end

      end
    end
  end

  def load_dependency(params) 
    if params.include?(:dependency) and params[:dependency].include?(:id)
      Dependency.find_by_id(params[:dependency][:id])
    end
  end

  def load_parent_dependency(params) 
    if params.include?(:dependency) and params[:dependency].include?(:parent_id)
      Dependency.find_by_id(params[:dependency][:parent_id])
    end
  end

  def load_user(params) 
    if params.include?(:user) and params[:user].include?(:id_type) and params[:user].include?(:person_id)
      User.find_by_document(params[:user][:id_type], params[:user][:person_id])
    end
  end
end
