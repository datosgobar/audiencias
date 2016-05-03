class ManagementController < ApplicationController

  before_action :require_login

  def admin_landing
    @dependencies = Dependency.for_user @current_user
  end

  def operator_landing

  end

  def list_admins
    render json: User.where(is_superadmin: true)
  end

  def new_admin
    user = User.find_by_document(params[:id_type], params[:id])
    newUser = !user
    
    unless user
      user = User.new
      user.id_type = params[:id_type]
      user.dni = params[:id]
      require 'securerandom'
      user.password = SecureRandom.urlsafe_base64(8)
    end

    user.is_superadmin = true
    user.name = params[:name]
    user.surname = params[:surname]
    user.email = params[:email]
    
    if user.save 
      user.send_password_reset if newUser
      render json: { success: true, new: newUser }
    else
      render json: { success: false, errors: user.errors.messages }
    end
  end

  def remove_admin
    user = User.find_by_document(params[:id_type], params[:id])
    user.is_superadmin = false
    if user.save 
      render json: { success: true }
    else
      render json: { success: false, errors: user.errors.messages }
    end
  end

end
