class audiencias.views.AudienceApplicantForm extends Backbone.View
  template: JST["backbone/templates/operator/audience/applicant_form"]
  events: 
    'change .nationality-radio': 'nationalityChanged'
    'click .confirm-save': 'verifyForm'

  initialize: (@options) ->
    @audience = @options.audience

  render: =>
    @$el.html(@template(audience: @audience))
    @setTooltip()
    @setAutoComplete()

  setTooltip: =>
    @$el.find('.tooltip').tooltipster(
      content: "Solicite primero el pasaporte, de no contar con este solicite id."
      maxWidth: 250
      position: 'right'
      theme: 'tooltipster-light'
    )

  setAutoComplete: =>
    if @$el.find('#nationality-argentine').is(':checked')
      @$el.find('.person-id-input').autocomplete(
        source: @searchPerson
        select: @autocompleteSelect
      )

  searchPerson: (request, response) =>
    id_type = @$el.find('.id-type-input').val()
    person_id = request.term
    $.ajax(
      url: '/intranet/autocomplete_persona'
      method: 'GET'
      data: { id_type: id_type, person_id: person_id }
      success: response
    )

  autocompleteSelect: (e, ui) =>
    if ui and ui.item and ui.item.person
      person = ui.item.person
      @$el.find('.name-input').val(person.name)
      @$el.find('.surname-input').val(person.surname)

  nationalityChanged: =>
    newCountry = @$el.find('.nationality-radio:checked').val()
    applicantPerson = @audience.get('applicant').get('person')
    applicantPerson.country = newCountry
    @audience.get('applicant').set('person', applicantPerson)
    @render()

  verifyForm: =>
    applicant = @audience.get('applicant')
    person = applicant.get('person')

    if @$el.find('#nationality-argentine').is(':checked')
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
      id_type: if person.country == 'Argentina' then @$el.find('.id-type-input').val() else country
    }
    applicantAttr = {
      ocupation: @$el.find('.position-input').val().trim()
      person: personAttr
    }

    if @$el.find('#applicant-didnt-participated').is(':checked')
      applicantAttr.absent = true
    else if @$el.find('#applicant-participated').is(':checked') 
      applicantAttr.absent = false

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
    
    if personAttr.email && personAttr.email.length > 0
      personEmailValid = @validateEmail(personAttr.email)
      valid = valid and personEmailValid
      @$el.find('.email-input').toggleClass('invalid', !personEmailValid)

    personCountryValid = @validateCountry(personAttr.country)
    valid = valid and personCountryValid
    @$el.find('.countries-select').toggleClass('invalid', !personCountryValid)
    
    if personAttr.ocupation && personAttr.ocupation.length > 0
      applicantOcupationValid = @validateName(applicantAttr.ocupation)
      valid = valid and applicantOcupationValid
      @$el.find('.position-input').toggleClass('invalid', !applicantOcupationValid)

    if valid
      @updateApplicant(applicantAttr)

  updateApplicant: (applicantData) =>
    data = { 
      audience: { 
        id: @audience.get('id'),
        new: !!@audience.get('new')
        applicant: applicantData 
      } 
    }
    if data.audience.new 
      data.audience.obligee_id = audiencias.globals.obligees.currentObligee().get('id')
      data.audience.author_id = audiencias.globals.users.currentUser().get('id')
    $.ajax(
      url: '/intranet/editar_audiencia'
      method: 'POST'
      data: data
      success: (response) =>
        if response.success and response.audience
            response.audience.editingApplicant = false
            response.audience.new = false
            @audience.forceUpdate(response.audience)
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