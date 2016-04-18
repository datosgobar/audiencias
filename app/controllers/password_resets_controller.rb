class PasswordResetsController < ApplicationController

  # TODO: mostrar y i18n mensajes de error

  def new
  end

  def create
    user = User.find_by_dni(params[:dni])
    if user
      user.send_password_reset 
      redirect_to root_url
    else
      redirect_to send_password_reset_form_path
    end
  end

  def edit
    @user = User.find_by_password_reset_token!(params[:token])
  end

  def update
    @user = User.find_by_password_reset_token!(params[:token])
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to send_password_reset_form_path
    else
      @user.password = params[:user][:password]
      if @user.save 
        redirect_to root_url
      else
        render :edit
      end
    end
  end
end
