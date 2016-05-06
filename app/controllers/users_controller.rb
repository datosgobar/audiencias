class UsersController < ApplicationController

  def login
    redirect_to root_url if @current_user
  end

  def login_attempt
    user = User.find_by_document(params[:id_type], params[:id])
    password = params[:password]

    if not user or not user.authenticate(password)
      render json: { success: false, message: 'Documento o contraseña invalida' }
      return
    end

    unless user.has_any_permit
      render json: { success: false, message: 'El usuario ingresado no tiene permisos para acceder al sistema.' }
      return
    end

    if params[:remember_me]
      cookies.permanent[:auth_token] = user.auth_token
    else
      cookies[:auth_token] = user.auth_token
    end
    render json: { success: true }
      
  end

  def logout
    cookies.delete(:auth_token)
    redirect_to root_url
  end

  def send_password_reset_email
    user = User.find_by_document(params[:id_type], params[:id])
    if user
      user.send_password_reset 
    end
    render json: { success: true }
  end

  def update_password 
  end

end
