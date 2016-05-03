class UsersController < ApplicationController

  def login
    redirect_to root_url if @current_user
  end

  def login_attempt
    user = User.find_by_document(params[:id_type], params[:id])
    password = params[:password]
    if user and user.authenticate(password)
      if params[:remember_me]
        cookies.permanent[:auth_token] = user.auth_token
      else
        cookies[:auth_token] = user.auth_token
      end
      if user.dependencies.length > 0 or user.is_superadmin
        redirect_to admin_landing_path
      elsif user.obligees.length > 0
        redirect_to operator_landing_path
      else
        @message = 'El usuario ingresado ya no tiene permisos de acceder al sistema.' 
        render :login
      end
    else
      @message = 'Las credenciales ingresadas no son validas.'
      render :login
    end
  end

  def logout
    cookies.delete(:auth_token)
    redirect_to root_url
  end

end
