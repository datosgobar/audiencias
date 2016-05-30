class OperatorsController < ApplicationController

  before_action :require_login, :authorize_user

  def operator_landing
    if params[:sujeto_obligado]
      @current_obligee = Obligee.find_by_id(params[:sujeto_obligado])
    else @current_user.obligees.length > 0
      redirect_to operator_landing_path(sujeto_obligado: @current_user.obligees.first.id)
      return
    end

    unless @current_obligee and @current_user.has_permission_for(@current_obligee)
      raise CanCan::AccessDenied.new
    end

    @obligees = @current_user.obligees.as_json
    @obligees << @current_obligee.as_json unless @current_user.obligees.include?(@current_obligee)
    @audiences = @current_obligee.audiences
  end

  def new_audience
    if params[:sujeto_obligado]
      @current_obligee = Obligee.find_by_id(params[:sujeto_obligado])
      unless @current_obligee and @current_user.has_permission_for(@current_obligee)
        raise CanCan::AccessDenied.new
      end

      @obligees = @current_user.obligees.as_json
      @obligees << @current_obligee.as_json unless @current_user.obligees.include?(@current_obligee)
    else
      redirect_to operator_landing_path
    end
  end

  def audience_editor
    if params[:audiencia]
      @current_audience = Audience.find_by_id(params[:audiencia])
    end
    redirect_to operator_landing_path unless @current_audience

    @current_obligee = @current_audience.obligee
    unless @current_user.has_permission_for(@current_obligee)
      raise CanCan::AccessDenied.new
      return
    end
  end

  def edit_audience
    if params[:audience] and params[:audience][:id]
      @current_audience = Audience.find_by_id(params[:audience][:id])
    elsif params[:audience] and params[:audience][:new]
      @current_audience = Audience.new(
        obligee_id: params[:audience][:obligee_id], 
        author_id: params[:audience][:author_id]
      )
    end

    unless @current_audience
      render json: { success: false }
      return
    end

    @current_audience.update_minor_attributes(params[:audience])
    if @current_audience.save 
      render json: { success: true, audience: @current_audience }
    else
      render json: { success: false, errors: @current_audience.errors.messages }
    end
  end

  def delete_audience
  end

end