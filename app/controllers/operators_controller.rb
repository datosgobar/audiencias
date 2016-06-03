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
    
    page = (params[:pagina] || 1).to_i
    per_page = 10
    total_audiences = @current_obligee.audiences.where(deleted: false)
    @audiences = total_audiences.paginate({
      page: page,
      per_page: per_page
    }).order('created_at DESC')
    @pagination = {
      total_audiences: total_audiences.length,
      total_pages: (total_audiences.length / per_page.to_f).ceil,
      current_page: page,
      per_page: per_page
    }
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
    unless params[:audience] and params[:audience][:id]
      render json: { success: false }
      return
    end

    audience = Audience.find_by_id(params[:audience][:id])
    unless audience
      render json: { success: false }
      return
    end

    audience.deleted = true
    audience.deleted_at = DateTime.now

    if audience.save 
      render json: { success: true }
    else
      render json: { success: false }
    end
  end

  def delete_participant
    unless params[:audience] and params[:audience][:id]
      render json: { success: false }
      return
    end

    audience = Audience.find_by_id(params[:audience][:id])
    unless audience 
      render json: { success: false }
      return
    end

    participant = audience.participants.find_by_id(params[:participant][:id])
    if participant and participant.destroy
      render json: { success: true, participants: audience.participants }
    else
      render json: { success: false }
    end
  end

  def delete_represented
    unless params[:audience] and params[:audience][:id]
      render json: { success: false }
      return
    end

    audience = Audience.find_by_id(params[:audience][:id])
    unless audience 
      render json: { success: false }
      return
    end

    applicant = audience.applicant
    applicant.remove_represented
    if applicant.save 
      render json: { success: true, applicant: applicant }
    else
      render json: { success: false }
    end
  end

  def publish_audience
    unless params[:audience] and params[:audience][:id]
      render json: { success: false }
      return
    end

    audience = Audience.find_by_id(params[:audience][:id])
    unless audience 
      render json: { success: false }
      return
    end
    
    if audience.state == 'valid'
      audience.published = true
    else 
      render json: { success: false }
      return
    end 

    if audience.save 
      render json: { success: true }
    else
      render json: { success: false }
    end
  end

  def person_autocomplete
    people = [{
      label: '11478800',
      person: { id_type: 'dni', person_id: '11478800', name: 'Catalina', surname: 'Nosiglia' }
    }, {
      label: '11198258',
      person: { id_type: 'dni', person_id: '11198258', name: 'Luis', surname: 'Quevedo' }
    }, {
      label: '22293105',
      person: { id_type: 'dni', person_id: '22293105', name: 'Maria Julieta', surname: 'García Lenzi' }
    }, {
      label: '28750416',
      person: { id_type: 'dni', person_id: '28750416', name: 'Hernan Daniel', surname: 'Muñoz' }
    }, {
      label: '31422861',
      person: { id_type: 'dni', person_id: '31422861', name: 'Nicolas', surname: 'Roibas' }
    }, {
      label: '23327604',
      person: { id_type: 'dni', person_id: '23327604', name: 'Martin', surname: 'Chojo' }
    }, {
      label: '17605003',
      person: { id_type: 'dni', person_id: '17605003', name: 'Patricia', surname: 'Holzman' }
    }, {
      label: '22678667',
      person: { id_type: 'dni', person_id: '22678667', name: 'Carlos', surname: 'Verna' }
    }, {
      label: '20026746',
      person: { id_type: 'dni', person_id: '20026746', name: 'Domingo', surname: 'Amaya' }
    }, {
      label: '22653243',
      person: { id_type: 'dni', person_id: '22653243', name: 'Marina', surname: 'Klemensiewicz' }
    }, {
      label: '13753135',
      person: { id_type: 'dni', person_id: '13753135', name: 'Manuel', surname: 'Sobrado' }
    }]
    id_type = params[:id_type]
    person_id = params[:person_id]
    if id_type and person_id
      filteredPeople = people.select { |p| p[:label].include?(person_id) && p[:person][:id_type] == id_type }
    else 
      filteredPeople = [] 
    end
    render json: filteredPeople 
  end

end