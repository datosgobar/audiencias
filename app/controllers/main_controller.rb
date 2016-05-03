class MainController < ApplicationController

  before_action :require_login

  def home
    if @current_user.dependencies.length > 0 or @current_user.is_superadmin
      redirect_to admin_landing_path
    elsif @current_user.obligees.length > 0
      redirect_to operator_landing_path
    else
      redirect_to logout_path
    end
  end

end
