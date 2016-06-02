class audiencias.views.AudienceRepresentedEntityForm extends Backbone.View
  template: JST["backbone/templates/operator/audience/represented_entity_form"]
  events:
    'change .nationality-radio': 'nationalityChange'
    'click .confirm-save': 'validateForm'

  initialize: (options) ->
    @audience = options.audience
    @applicant = @audience.get('applicant')

  render: ->
    @$el.html(@template(
      audience: @audience
    )) 

  nationalityChange: =>
    newCountry = @$el.find('.nationality-radio:checked').val()
    represented = @applicant.get('represented_legal_entity')
    represented.country = newCountry
    @applicant.set('represented_legal_entity', represented)
    @render()

  validateForm: =>
    if @$el.find('#represented-nationality-argentine').is(':checked')
      country = 'Argentina'
    else
      country = @$el.find('.countries-select').val()

    entityAttrs = {
      country: country
      name: @$el.find('.name-input').val().trim()
      email: @$el.find('.email-input').val().trim()
      telephone: @$el.find('.telephone-input').val().trim()
      cuit: (@$el.find('.cuit-input').val() || '').trim()
    }
    valid = true
    
    countryValid = @validateCountry(entityAttrs.country)
    valid = valid and countryValid
    @$el.find('.countries-select').toggleClass('invalid', !countryValid)
        
    nameValid = @validateName(entityAttrs.name)
    valid = valid and nameValid
    @$el.find('.name-input').toggleClass('invalid', !nameValid)
    
    if entityAttrs.email.length > 0
      emailValid = @validateEmail(entityAttrs.email)
      valid = valid and emailValid
      @$el.find('.email-input').toggleClass('invalid', !emailValid)

    if country == 'Argentina'
      cuitValid = @validateName(entityAttrs.cuit)
      valid = valid and cuitValid
      @$el.find('.cuit-input').toggleClass('invalid', !cuitValid)

    if valid
      @updateRepresented(entityAttrs)

  updateRepresented: (entityDate) =>
    data = { 
      audience: { 
        id: @audience.get('id'),
        applicant: { represented_legal_entity: entityDate } 
      } 
    }
    $.ajax(
      url: '/intranet/editar_audiencia'
      method: 'POST'
      data: data
      success: (response) =>
        if response.success and response.audience
            response.audience.editingRepresented = false
            audiencias.globals.audiences.updateAudience(response.audience)
    )

  validateCountry: (country) ->
    country == 'Argentina' or audiencias.globals.countries.indexOf(country) > -1

  validateName: (name) ->
    name.trim().length > 0 

  validateEmail: (email) ->
    /[\w+\-.]+@[a-z\d\-.]+\.[a-z]+/i.test(email)