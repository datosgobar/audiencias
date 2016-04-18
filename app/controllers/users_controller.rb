class UsersController < ApplicationController

  def login
    redirect_to root_url if @current_user
  end

  def login_attempt
    user = User.find_by_dni(params[:dni])
    password = params[:password]
    if user and user.authenticate(password)
      if params[:remember_me]
        cookies.permanent[:auth_token] = user.auth_token
      else
        cookies[:auth_token] = user.auth_token
      end
      # TODO: redirigir a la url que se queria ingresar
      redirect_to root_url
    else
      # TODO: mensaje de usuario/contraseña invalida
      redirect_to login_url
    end
  end

  def logout
    cookies.delete(:auth_token)
    redirect_to root_url
  end

end
