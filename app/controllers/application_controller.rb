class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_current_user

  rescue_from CanCan::AccessDenied do |exception|
    if request.method == 'GET'
      render 'errors/forbidden'
    else
      head :forbidden
    end
  end

  def set_current_user
    @current_user ||= User.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
  end

  def require_login
    redirect_to login_url unless @current_user
  end

  def authorize_user
    authorize!(params[:action].to_sym, self)
  end

  def current_user
    @current_user
  end

  def current_ability
    @current_ability ||= Ability.new(current_user, params)
  end

end
