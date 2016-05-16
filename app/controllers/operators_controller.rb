class OperatorsController < ApplicationController

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
    @current_obligee = @obligees.find(params[:obligee_id])
    unless @current_obligee or ['superadmin', 'admin'].include?(@current_user.role)
      raise CanCan::AccessDenied.new
      return
    end
  end
end