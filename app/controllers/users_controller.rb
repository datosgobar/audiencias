class UsersController < ApplicationController

  def login
    redirect_to root_url if @current_user
  end

  def login_attempt
    user = User.find_by_dni(params[:dni])
    password = params[:password]
    if user and user.authenticate(password)
      session[:current_user] = user
      # TODO: redirigir a la url que se queria ingresar
      redirect_to root_url
    else
      redirect_to login_url
    end
  end

  def logout
    session[:current_user] = nil
    redirect_to root_url
  end

end
