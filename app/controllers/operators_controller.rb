class OperatorsController < ApplicationController

  before_action :require_login, :authorize_user

  def operator_landing
    if params[:sujeto_obligado]
      @current_obligee = Obligee.find_by_id(params[:sujeto_obligado])
    elsif @current_user.obligees.length > 0
      redirect_to operator_landing_path(sujeto_obligado: @current_user.obligees.first.id)
      return
    end

    unless @current_obligee and @current_user.has_permission_for(@current_obligee)
      raise CanCan::AccessDenied.new
    end

    @obligees = @current_user.obligees.as_json
    @obligees << @current_obligee.as_json unless @current_user.obligees.include?(@current_obligee)
    
    if params[:q] and params[:q].length > 0
      @query = params[:q]
      @audiences = @current_obligee.search_audiences(@query)
    else
      @audiences = @current_obligee.all_audiences
    end

    page = (params[:pagina] || 1).to_i
    @audiences = @audiences.paginate(page: page)
    @pagination = {
      total_audiences: @audiences.total_entries,
      total_pages: @audiences.total_pages,
      current_page: page,
      per_page: Audience.per_page
    }
  end

  def new_audience
    if params[:sujeto_obligado]
      @current_obligee = Obligee.find_by_id(params[:sujeto_obligado])
      @obligees = @current_user.obligees.as_json
      @obligees << @current_obligee.as_json unless @current_user.obligees.include?(@current_obligee)
    else
      redirect_to operator_landing_path
    end
  end

  def submit_new_audience
    @current_audience = Audience.new(
      obligee_id: params[:obligee][:id], 
      author_id: params[:audience][:author_id]
    )
    @current_audience.update_minor_attributes(params[:audience])
    if @current_audience.save 
      render json: { success: true, audience: @current_audience }
    else
      render json: { success: false, errors: @current_audience.errors.messages }
    end
  end

  def audience_editor
    if params[:audiencia]
      @current_audience = Audience.find_by_id(params[:audiencia])
    end
    if not @current_audience or @current_audience.deleted 
      redirect_to operator_landing_path(sujeto_obligado: @current_audience.obligee.id)
    end

    @current_obligee = @current_audience.obligee
    unless @current_user.has_permission_for(@current_obligee)
      raise CanCan::AccessDenied.new
      return
    end
  end

  def edit_audience
    if params[:audience] and params[:audience][:id]
      @current_audience = Audience.find_by_id(params[:audience][:id])
    end

    @current_audience.update_minor_attributes(params[:audience])
    if @current_audience.save 
      render json: { success: true, audience: @current_audience }
    else
      render json: { success: false, errors: @current_audience.errors.messages }
    end
  end

  def delete_audience
    audience = Audience.find_by_id(params[:audience][:id])
    audience.deleted = true
    audience.deleted_at = DateTime.now

    if audience.save 
      render json: { success: true }
    else
      render json: { success: false }
    end
  end

  def delete_participant
    audience = Audience.find_by_id(params[:audience][:id])
    participant = audience.participants.find_by_id(params[:participant][:id])
    if participant and participant.destroy
      render json: { success: true, audience: audience }
    else
      render json: { success: false }
    end
  end

  def delete_represented
    audience = Audience.find_by_id(params[:audience][:id])
    applicant = audience.applicant
    applicant.remove_represented
    if applicant.save 
      render json: { success: true, applicant: applicant }
    else
      render json: { success: false }
    end
  end

  def publish_audience
    audience = Audience.find_by_id(params[:audience][:id])
    if audience.state == 'valid'
      audience.published = true
      audience.publish_date = DateTime.now
    else 
      render json: { success: false }
      return
    end 

    if audience.save 
      audience.send_publish_email
      render json: { success: true }
    else
      render json: { success: false }
    end
  end

end