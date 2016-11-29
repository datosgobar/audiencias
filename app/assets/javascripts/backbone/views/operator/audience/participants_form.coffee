class audiencias.views.AudienceParticipantsForm extends audiencias.views.Form
  template: JST["backbone/templates/operator/audience/participants_form"]
  className: 'person-form'
  events:
    'change .nationality-radio': 'nationalityChanged'
    'click .confirm-save': 'validateForm'
    'autocompleteperson .person-id-input': 'onPersonAutocompleteSelected'
    'autocompleteremoved .person-id-input': 'onPersonAutocompleteRemoved'

  initialize: (options) ->
    @participant = options.participantBeingEdited
    @audience = options.audience

  render: ->
    @$el.html(@template(
      participant: @participant, 
      disableNameInput: !@userCanWriteName
    ))
    new audiencias.views.Tooltip({
      el: @$el.find('.id-tooltip')
      content: "Solicite primero el pasaporte, de no contar con este solicite id."
    })

    new audiencias.views.Tooltip({
      el: @$el.find('.dni-tooltip')
      content: "Debe ingresar el numero de documento sin puntos ni espacios."
    })


    @setPersonAutoComplete('.person-id-input')
    @setMaxLength()

  onPersonAutocompleteSelected: (e, person) =>
    @$el.find('.name-input').val(person.name).prop('disabled', true)

  onPersonAutocompleteRemoved: =>
    @$el.find('.name-input').val('').prop('disabled', !@userCanWriteName)

  nationalityChanged: =>
    newCountry = @$el.find('.nationality-radio:checked').val()
    @userCanWriteName = newCountry != 'Argentina'
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
      country: country
      id_type: if country == 'Argentina' then @$el.find('.id-type-input').val() else ''
    }
    participantAttr = {
      ocupation: @$el.find('.position-input').val().trim()
      person: personAttr
    }

    valid = true
    
    personNameValid = @validateName(personAttr.name)
    valid = valid and personNameValid
    @$el.find('.name-input').toggleClass('invalid', !personNameValid)
    
    personIdValid = @validatePersonId(personAttr.person_id, personAttr.country)
    personAlsoParticipant = (@audience.get('applicant') and @audience.get('applicant').get('person').person_id == personAttr.person_id)
    personAlsoRepresented = (@audience.get('applicant') and @audience.get('applicant').get('represented_person') and @audience.get('applicant').get('represented_person').person_id == personAttr.person_id)
    personIsTheObligee = (@audience.get('obligee').get('person').person_id == personAttr.person_id) 
    valid = valid and personIdValid and !personAlsoParticipant and !personAlsoRepresented and !personIsTheObligee
    @$el.find('.person-id-input').toggleClass('invalid', !personIdValid)

    personCountryValid = @validateCountry(personAttr.country)
    valid = valid and personCountryValid
    @$el.find('.countries-select').toggleClass('invalid', !personCountryValid)

    if valid
      @submitParticipant(participantAttr) 
    else 
      @$el.find('.errors .person-also-participant').toggleClass('hidden', !personAlsoParticipant)
      @$el.find('.errors .represented-person-also-participant').toggleClass('hidden', !personAlsoRepresented)
      @$el.find('.errors .obligee-also-participant').toggleClass('hidden', !personIsTheObligee)

  submitParticipant: (participantData) =>
    data = { participant: participantData }
    callback = => @trigger('participantSubmitted')
    @audience.submitEdition(data, callback)