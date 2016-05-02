class ManagementController < ApplicationController

  before_action :require_login

  def admin_landing
    @dependencies = Dependency.for_user @current_user
  end

  def operator_landing

  end

  def list_admins
    render json: User.where(is_superadmin: true)
  end

end
