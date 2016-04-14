class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_current_user

  def set_current_user
    @current_user = session[:current_user]
  end

  def require_login
    redirect_to login_url unless @current_user
  end

end
