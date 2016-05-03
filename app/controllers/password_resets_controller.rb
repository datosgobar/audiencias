class PasswordResetsController < ApplicationController

  def new
  end

  def create
    user = User.find_by_document(params[:id_type], params[:id])
    if user
      user.send_password_reset 
    end
    @submitted = true
    render :new
  end

  def edit
    @user = User.find_by_password_reset_token!(params[:token])
    if @user.password_reset_sent_at < 1.days.ago
      @expired = true
    end
  end

  def update
    @user = User.find_by_password_reset_token!(params[:token])
    if @user.password_reset_sent_at < 1.days.ago
      @expired = true
    else
      @user.password = params[:user][:password]
      if @user.save 
        @changed = true
      else
        # mostrar error
        # contraseña muy corta, etc
      end
    end
    render :edit
  end

end
