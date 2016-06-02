class audiencias.views.AudienceRepresentedApplicantForm extends Backbone.View
  template: JST["backbone/templates/operator/audience/represented_person_form"]
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
    represented = @applicant.get('represented_person')
    represented.country = newCountry
    @applicant.set('represented_person', represented)
    @render()

  validateForm: =>
    if @$el.find('#represented-nationality-argentine').is(':checked')
      country = 'Argentina'
    else
      country = @$el.find('.countries-select').val()

    personAttr = {
      person_id: @$el.find('.person-id-input').val().trim()
      name: @$el.find('.name-input').val().trim()
      surname: @$el.find('.surname-input').val().trim()
      email: @$el.find('.email-input').val().trim()
      telephone: @$el.find('.telephone-input').val().trim()
      country: country
      id_type: if country == 'Argentina' then @$el.find('.id-type-input').val() else country
      ocupation: @$el.find('.position-input').val().trim()
    }

    valid = true
    
    personNameValid = @validateName(personAttr.name)
    valid = valid and personNameValid
    @$el.find('.name-input').toggleClass('invalid', !personNameValid)
    
    personSurnameValid = @validateName(personAttr.surname)
    valid = valid and personSurnameValid
    @$el.find('.surname-input').toggleClass('invalid', !personSurnameValid)
    
    personIdValid = @validatePersonId(personAttr.person_id, personAttr.country)
    valid = valid and personIdValid
    @$el.find('.person-id-input').toggleClass('invalid', !personIdValid)
    
    if personAttr.email.length > 0
      personEmailValid = @validateEmail(personAttr.email)
      valid = valid and personEmailValid
      @$el.find('.email-input').toggleClass('invalid', !personEmailValid)

    personCountryValid = @validateCountry(personAttr.country)
    valid = valid and personCountryValid
    @$el.find('.countries-select').toggleClass('invalid', !personCountryValid)
    
    personOcupationValid = @validateName(personAttr.ocupation)
    valid = valid and personOcupationValid
    @$el.find('.position-input').toggleClass('invalid', !personOcupationValid)

    if valid
      @updateRepresented(personAttr)

  updateRepresented: (personData) =>
    data = { 
      audience: { 
        id: @audience.get('id'),
        applicant: { represented_person: personData } 
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

  validatePersonId: (person_id, country) ->
    if country == 'Argentina'
      !!parseInt(person_id) and parseInt(person_id) > 0
    else
      person_id.length > 0

  validateName: (name) ->
    name.trim().length > 0 

  validateEmail: (email) ->
    /[\w+\-.]+@[a-z\d\-.]+\.[a-z]+/i.test(email)

  validateCountry: (country) ->
    country == 'Argentina' or audiencias.globals.countries.indexOf(country) > -1