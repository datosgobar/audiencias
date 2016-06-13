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
      participant: @participant
    ))
    new audiencias.views.Tooltip({
      el: @$el.find('.id-tooltip')
      content: "Solicite primero el pasaporte, de no contar con este solicite id."
    })
    @setPersonAutoComplete('.person-id-input')
    @setMaxLength()

  onPersonAutocompleteSelected: (e, person) =>
    @$el.find('.name-input').val(person.name).prop('disabled', true)

  onPersonAutocompleteRemoved: =>
    @$el.find('.name-input').prop('disabled', false).val('')

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
    
    personIdValid = @validatePersonId(personAttr.person_id, personAttr.country)
    valid = valid and personIdValid
    @$el.find('.person-id-input').toggleClass('invalid', !personIdValid)

    personCountryValid = @validateCountry(personAttr.country)
    valid = valid and personCountryValid
    @$el.find('.countries-select').toggleClass('invalid', !personCountryValid)

    @submitParticipant(participantAttr) if valid

  submitParticipant: (participantData) =>
    data = { participant: participantData }
    callback = => @trigger('participantSubmitted')
    @audience.submitEdition(data, callback)