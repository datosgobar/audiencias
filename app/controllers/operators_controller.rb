class OperatorsController < ApplicationController

  before_action :require_login, :authorize_user

  def operator_landing
    obligees = @current_user.obligees
    if obligees.length > 0
      redirect_to audience_list_path(obligee_id: obligees.first.id)
    else
      raise CanCan::AccessDenied.new
    end
  end

  def audience_list
    @current_obligee = Obligee.find_by_id(params[:obligee_id])
    @obligees = @current_user.obligees
    unless @current_obligee and @current_user.has_permission_for(@current_obligee)
      raise CanCan::AccessDenied.new
      return
    end
    @audiences = @current_obligee.audiences
  end

  def audience_editor
    @current_obligee = Obligee.find_by_id(params[:obligee_id])
    @obligees = @current_user.obligees
    unless @current_obligee and @current_user.has_permission_for(@current_obligee)
      raise CanCan::AccessDenied.new
      return
    end
  end

  def edit_applicant
    # crear si no existe, editar sino
  end

  def edit_represented
    # crear si no existe, editar sino
  end

  def edit_participant
    # crear si no existe, editar sino
  end

  def remove_participant
  end

  def edit_main_info
  end

  def delete_audience
    # crear si no existe, editar sino
  end

end