class UtilsController < ApplicationController
  
  before_action :require_login, :authorize_user

  def person_autocomplete
    id_type = params[:id_type]
    person_id = params[:person_id]
    country = params[:country]
    responsePeople = []

    if person_id and id_type and id_type.length > 0
      person = Person.find_by_document(id_type, person_id)
      responsePeople << person if person
    elsif person_id and country
      person = Person.where(person_id: person_id, country: country)
      responsePeople += person
    else
      render json: { success: false }
      return
    end

    if responsePeople.length == 0 and ['dni', 'lc', 'le'].include?(id_type) and Rails.env == "production"
      sintys = Sintys.new
      begin
        response = sintys.identificar_persona_fisica(id_type.to_sym, person_id)
        responsePeople = parse_sintys_people(response[:results]) if response[:results].length > 0
      rescue
      end
    end
    render json: { success: true, results: responsePeople }
  end

  def address_autocomplete
    address = params[:address]
    unless address
      render json: { success: false }
      return
    end
    google_geocoding = GoogleGeocoding.new
    begin
      google_response = google_geocoding.search_address(address)
      response_address = parse_google_address(google_response)
    rescue
      response_address = []
    end
    render json: { success: true, results: response_address }
  end

  def legal_entity_autocomplete
    cuit = params[:cuit]
    unless cuit 
      render json: { success: false }
      return 
    end
    response_entities = LegalEntity.where(cuit: cuit, country: 'Argentina')
    if response_entities.length == 0 and Rails.env == 'production'
      sintys = Sintys.new
      begin
        response = sintys.identificar_persona_juridica(cuit)
        response_entities = parse_sintys_entities(response[:results]) if response[:results].length > 0
      rescue
      end
    end
    render json: { success: true, results: response_entities }
  end

  private

  def parse_sintys_people(sintys_people)
    sintys_people.collect do |person|
      { 
        name: person['deno'].titleize,
        id_type: person['tdoc'].downcase,
        person_id: person['ndoc']
      }
    end
  end

  def parse_sintys_entities(sintys_entities) 
    sintys_entities.collect do |entity|
      { 
        name: entity['razonSocial'],
        cuit: entity['cuit']
      }
    end
  end

  def parse_google_address(google_address)
    google_address.collect do |address|
      {
        full_address: address['formatted_address'],
        lat: address['geometry']['location']['lat'],
        lng: address['geometry']['location']['lng']
      }
    end
  end

end
