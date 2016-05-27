class UsersController < ApplicationController
  before_action :require_login, only: [:user_config, :change_user_config]

  def login
    redirect_to root_url if @current_user
  end

  def login_attempt
    user = User.find_by_document(params[:id_type], params[:person_id])
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
    user = User.find_by_document(params[:id_type], params[:person_id])
    if user
      user.send_password_reset 
      render json: { success: true }
      return
    end
    render json: { success: false }
  end

  def password_reset_form
    user = User.find_by_password_reset_token(params[:token])
    @formOptions = { userFound: !!user }
    if user
      @formOptions[:tokenExpired] = user.password_reset_sent_at < 1.days.ago
    end
  end

  def update_password
    user = User.find_by_password_reset_token(params[:token])
    unless user 
      render json: { success: false }
      return
    end

    user.password = params[:password]
    if user.save 
      render json: { success: true }
    else
      render json: { success: false, erros: user.errors }
    end

  end

  def user_config
  end

  def change_user_config
    @current_user.email = params[:user][:email] if params[:user][:email]
    @current_user.password = params[:user][:password] if params[:user][:password]
    if @current_user.save 
      render json: { success: true, user: @current_user }
    else 
      render json: { success: false, erros: @current_user.errors }
    end
  end

end
