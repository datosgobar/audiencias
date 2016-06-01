class audiencias.views.AudienceParticipantsForm extends Backbone.View
  template: JST["backbone/templates/operator/audience/participants_form"]
  className: 'person-form'
  events:
    'change .nationality-radio': 'nationalityChanged'
    'click .confirm-save': 'validateForm'

  initialize: (options) ->
    @participant = options.participantBeingEdited
    @audience = options.audience

  render: ->
    @$el.html(@template(
      participant: @participant
    ))
    @setTooltip()

  setTooltip: =>
    @$el.find('.id-tooltip').tooltipster(
      content: "Solicite primero el pasaporte, de no contar con este solicite id."
      maxWidth: 250
      position: 'right'
      theme: 'tooltipster-light'
    )

  nationalityChanged: =>
    newCountry = @$el.find('.nationality-radio:checked').val()
    @participant.person.country = newCountry
    @render()

  validateForm: =>
    if @$el.find('#participant-nationality-argentine').is(':checked')
      country = 'Argentina'
    else
      country = @$el.find('.countries-select').val()

    personAttr = {
      person_id: @$el.find('.person-id-input').val().trim()
      name: @$el.find('.name-input').val().trim()
      surname: @$el.find('.surname-input').val().trim()
      country: country
      id_type: if country == 'Argentina' then @$el.find('.id-type-input').val() else country
    }
    participantAttr = {
      ocupation: @$el.find('.position-input').val().trim()
      person: personAttr
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

    personCountryValid = @validateCountry(personAttr.country)
    valid = valid and personCountryValid
    @$el.find('.countries-select').toggleClass('invalid', !personCountryValid)
    
    applicantOcupationValid = @validateName(participantAttr.ocupation)
    valid = valid and applicantOcupationValid
    @$el.find('.position-input').toggleClass('invalid', !applicantOcupationValid)

    @submitParticipant(participantAttr) if valid

  submitParticipant: (participantData) =>
    data = { 
      audience: { 
        id: @audience.get('id'),
        new: !!@audience.get('new')
        participant: participantData
      },
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
          response.audience.new = false
          @trigger('participantSubmitted')
          if data.audience.new 
            @audience.forceUpdate(response.audience)
          else
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