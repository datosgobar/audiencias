class Ability
  include CanCan::Ability

  def initialize(user)
    
    if user 
      role = user.role
      if role == 'superadmin'
        can :manage, :all
      end
    end
  end
end
