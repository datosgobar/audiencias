class ManagementController < ApplicationController

  before_action :require_login, :authorize_user

  def new_superadmin
    user = User.find_or_initialize(params[:user])
    new_user = user.new_record?
    user.is_superadmin = true

    if user.save 
      user.send_password_reset if new_user
      render json: { success: true, user: user }
    else
      render json: { success: false, errors: user.errors.messages }
    end
  end

  def new_admin
    user = User.find_or_initialize(params[:user])
    dependency = Dependency.find_by_id(params[:dependency][:id])
    if AdminAssociation.where(user: user, dependency: dependency).length > 0
      render json: { success: true, dependency: dependency, user: user }
      return
    end

    association = AdminAssociation.new(user: user, dependency: dependency)
    new_user = user.new_record?

    if user.save and association.save
      user.send_password_reset if new_user
      render json: { success: true, dependency: dependency, user: user }
    else
      render json: { success: false, user_errors: user.errors.messages, association_errors: association.errors.messages }
    end
  end

  def new_obligee
    person = Person.find_or_initialize(params[:person])
    dependency = Dependency.find_by_id(params[:dependency][:id])
    if dependency.obligee or person.has_active_obligee
      render json: { success: false }
      return
    end
    obligee = Obligee.new(person: person, dependency: dependency, position: params[:obligee][:position])
    dependency.obligee = obligee 

    if person.save and obligee.save and dependency.save
      render json: { success: true, dependency: dependency }
    else
      render json: { success: false, errors: { person: person.errors.messages, obligee: obligee.errors.messages, dependecy: dependency.errors.messages } }
    end
  end

  def new_operator
    dependency = Dependency.find_by_id(params[:dependency][:id])
    obligee = dependency.obligee
    user = User.find_or_initialize(params[:user])
    association = OperatorAssociation.new(user: user, obligee: obligee)

    if user.save and association.save 
      render json: { success: true, dependency: dependency, user: user }
    else
      render json: { success: false, errors: { user: user.errors.messages, operator: association.errors.messages } }
    end 
  end

  def remove_superadmin
    user = User.find_by_document(params[:user][:id_type], params[:user][:person_id])
    unless user 
      render json: { success: false }
      return
    end
    user.is_superadmin = false 
    if user.save 
      render json: { success: true, user: user }
    else 
      render json: { success: false }
    end
  end

  def remove_admin
    user = User.find_by_id(params[:user][:id])
    dependency = Dependency.find_by_id(params[:dependency][:id])
    association = AdminAssociation.where(user: user, dependency: dependency)
    if association.length > 0
      association.destroy_all
      render json: { success: true, user: user, dependency: dependency }
    else
      render json: { success: false }
    end

  end

  def remove_obligee
    dependency = Dependency.find_by_id(params[:dependency][:id])
    obligee = dependency.obligee
    unless obligee
      render json: { success: false }
      return
    end
    obligee.active = false
    dependency = obligee.dependency
    dependency.obligee = nil
    operatorAssociations = obligee.operator_associations
    if obligee.save and dependency.save and operatorAssociations.destroy_all
      render json: { success: true, dependency: dependency }
    else
      render json: { success: false }
    end
  end

  def remove_operator
    dependency = Dependency.find_by_id(params[:dependency][:id])
    obligee = dependency.obligee
    user = User.find_by_id(params[:user][:id])
    association = OperatorAssociation.where(user: user, obligee_id: obligee.id)
    unless association 
      render json: { success: false }
      return
    end
    if association.destroy_all 
      render json: { success: true, dependency: dependency, user: user }
    else
      render json: { success: false }
    end
  end

  def update_user
    user = User.find_by_document(params[:user][:id_type], params[:user][:person_id])
    unless user 
      render json: { success: false }
      return
    end 
    user.update_minor_attributes(params[:user])
    if user.save 
      render json: { success: true, user: user }
    else
      render json: { success: false }
    end
  end

  def update_obligee
    dependency = Dependency.find_by_id(params[:dependency][:id])
    obligee = dependency.obligee
    unless obligee
      render json: { success: false }
      return
    end
    person = obligee.person
    obligee.update_minor_attributes(params[:obligee])
    person.update_minor_attributes(params[:person])
    if person.save and obligee.save 
      render json: { success: true, dependency: dependency }
    else
      render json: { success: false }
    end
  end

  def update_dependency
    dependency = Dependency.find_by_id(params[:dependency][:id])
    dependency.update_minor_attributes(params[:dependency])
    if dependency.save 
      render json: { success: true, dependency: dependency }
    else
      render json: { success: false }
    end
  end

  def new_dependency
    dependency = Dependency.new(name: params[:dependency][:name], parent_id: params[:dependency][:parent_id])
    person = Person.find_or_initialize(params[:person])
    if person.has_active_obligee
      render json: { success: false, errors: 'El sujeto obligado está en otra dependencia' }
      return
    end
    obligee = Obligee.new(person: person, dependency: dependency, position: params[:obligee][:position])
    dependency.obligee = obligee
    if dependency.save and person.save and obligee.save
      render json: { success: true, dependency: dependency }
    else
      render json: { success: false, errors: { dependency: dependency.errors.full_messages, person: person.errors.full_messages, obligee: obligee.errors.full_messages } }
    end
  end

  def remove_dependency
    dependency = Dependency.find_by_id(params[:dependency][:id])
    unless dependency
      render json: { success: false }
      return
    end
    if dependency.mark_as_not_active 
      render json: { success: true, dependency: dependency }
    else
      render json: { success: false }
    end
  end

  def dependency_list
    dependencies = Dependency.list_for_user @current_user
    render json: { dependencies: dependencies }
  end

  def user_list
    users = User.all
    render json: { users: users }
  end

end
