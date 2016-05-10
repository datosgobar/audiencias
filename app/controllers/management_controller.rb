class ManagementController < ApplicationController

  before_action :require_login

  def superadmin_landing
    @dependencies = Dependency.for_user @current_user
  end

  def admin_landing
    @dependencies = Dependency.for_user @current_user
  end

  def operator_landing
  end

  def list_superadmins
    render json: User.where(is_superadmin: true)
  end

  def new_superadmin
    user = User.find_by_document(params[:id_type], params[:person_id])
    new_user = !user
    
    unless user
      user = User.new
      user.id_type = params[:id_type]
      user.person_id = params[:person_id]
      require 'securerandom'
      user.password = SecureRandom.urlsafe_base64(8)
    end

    user.is_superadmin = true
    user.name = params[:name]
    user.surname = params[:surname]
    user.email = params[:email]
    
    if user.save 
      user.send_password_reset if new_user
      render json: { success: true, new: new_user }
    else
      render json: { success: false, errors: user.errors.messages }
    end
  end

  def remove_superadmins
    users = params[:users]
    response = { users: [] }
    users.each do |key, userData|
      user = User.find_by_document(userData[:id_type], userData[:person_id])
      if user 
        user.is_superadmin = false
        userData[:success] = user.save 
      else 
        userData[:success] = false
      end
      response[:users] << userData
    end
    render json: response
  end

  def update_superadmins 
    users = params[:users]
    response = { users: [] }
    users.each do |key, userData|
      user = User.find_by_document(userData[:id_type], userData[:person_id])
      if user 
        user.update_attributes(userData)
        userData[:success] = user.save 
      else 
        userData[:success] = false
      end
      response[:users] << userData
    end
    render json: response
  end

  def search_user 
    user = User.find_by_document(params[:id_type], params[:person_id])
    if user 
      render json: { user: user }
    else
      render json: {}
    end
  end

end
