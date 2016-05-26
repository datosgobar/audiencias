class OperatorsController < ApplicationController

  before_action :require_login, :authorize_user

  def operator_landing
    obligees = @current_user.obligees
    if obligees.length > 0
      redirect_to audience_list_path(id: obligees.first.id)
    else
      raise CanCan::AccessDenied.new
    end
  end

  def audience_list
    @obligees = @current_user.obligees
    @current_obligee = @obligees.find_by_id(params[:obligee_id])
    unless @current_obligee
      raise CanCan::AccessDenied.new
      return
    end
  end

  def audience_editor
    @obligees = @current_user.obligees
    @current_obligee = @obligees.find_by_id(params[:obligee_id])
    unless @current_obligee
      raise CanCan::AccessDenied.new
      return
    end
  end
end