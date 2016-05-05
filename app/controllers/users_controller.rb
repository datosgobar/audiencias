class UsersController < ApplicationController

  def login
    redirect_to root_url if @current_user
  end

  def login_attempt
    user = User.find_by_document(params[:id_type], params[:id])
    password = params[:password]

    if user and user.authenticate(password)
      has_any_permit = user.dependencies.length > 0 or user.is_superadmin or user.obligees.length > 0
      
      if has_any_permit
      
        if params[:remember_me]
          cookies.permanent[:auth_token] = user.auth_token
        else
          cookies[:auth_token] = user.auth_token
        end
        render json: { success: true }

      else
        render json: { success: false, message: 'El usuario ingresado ya no tiene permisos para acceder al sistema.' }
      end
      
    else
      render json: { success: false, message: 'Documento o contraseña invalidas' }
    end
  end

  def logout
    cookies.delete(:auth_token)
    redirect_to root_url
  end

end
