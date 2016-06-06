class Ability
  include CanCan::Ability

  def initialize(user, params)
    
    if user 
      role = user.role
      can :manage, UtilsController

      if role == 'superadmin'
        can :manage, ManagementController
        can :manage, OperatorsController
      elsif role == 'admin'
        can :manage, ManagementController
        can :manage, OperatorsController
      elsif role == 'operator'
        can :manage, OperatorsController
      end
    end
  end
end
