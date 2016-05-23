class Ability
  include CanCan::Ability

  def initialize(user)
    
    if user 
      role = user.role

      if role == 'superadmin'
        can :manage, ManagementController
        can :manage, OperatorsController
      elsif role == 'admin'
        can :admin_landing, ManagementController
        can :dependency_list, ManagementController
        can :new_admin, ManagementController
        can :new_obligee, ManagementController
        can :new_operator, ManagementController
        can :new_sub_dependency, ManagementController
        can :remove_admin, ManagementController
        can :remove_obligee, ManagementController
        can :remove_operator, ManagementController
        can :update_user, ManagementController
        can :update_obligee, ManagementController
        can :update_dependency, ManagementController
        can :user_list, ManagementController
      end

    end
  end
end
