class audiencias.views.AudienceRepresentedApplicantForm extends audiencias.views.Form
  template: JST["backbone/templates/operator/audience/represented_person_form"]
  events:
    'change .nationality-radio': 'nationalityChange'
    'click .confirm-save': 'validateForm'
    'autocompleteperson .person-id-input': 'onPersonAutocompleteSelected'
    'autocompleteremoved .person-id-input': 'onPersonAutocompleteRemoved'

  initialize: (options) ->
    @audience = options.audience
    @applicant = @audience.get('applicant')

  render: ->
    @$el.html(@template(
      audience: @audience
    )) 
    @setPersonAutoComplete('.person-id-input')
    @setMaxLength()

  onPersonAutocompleteSelected: (e, person) =>
    @$el.find('.name-input').val(person.name).prop('disabled', true)

  onPersonAutocompleteRemoved: =>
    @$el.find('.name-input').prop('disabled', false).val('')
    
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
      email: @$el.find('.email-input').val().trim()
      telephone: @$el.find('.telephone-input').val().trim()
      country: country
      id_type: if country == 'Argentina' then @$el.find('.id-type-input').val() else ''
      ocupation: @$el.find('.position-input').val().trim()
    }

    valid = true
    
    personNameValid = @validateName(personAttr.name)
    valid = valid and personNameValid
    @$el.find('.name-input').toggleClass('invalid', !personNameValid)
    
    personIdValid = @validatePersonId(personAttr.person_id, personAttr.country)
    personAlsoParticipant = _.collect(@audience.get('participants'), (p) -> p.person.person_id).indexOf(personAttr.person_id) > -1
    personRepresentsItself = (@audience.get('applicant') and @audience.get('applicant').get('person').person_id == personAttr.person_id)
    personIsTheObligee = (@audience.get('obligee').get('person').person_id == personAttr.person_id) 
    valid = valid and personIdValid and !personAlsoParticipant and !personRepresentsItself and !personIsTheObligee
    @$el.find('.person-id-input').toggleClass('invalid', !personIdValid)
    
    if personAttr.email.length > 0
      personEmailValid = @validateEmail(personAttr.email)
      valid = valid and personEmailValid
      @$el.find('.email-input').toggleClass('invalid', !personEmailValid)

    personCountryValid = @validateCountry(personAttr.country)
    valid = valid and personCountryValid
    @$el.find('.countries-select').toggleClass('invalid', !personCountryValid)

    if valid
      @updateRepresented(personAttr)
    else 
      @$el.find('.errors .person-also-participant').toggleClass('hidden', !personAlsoParticipant)
      @$el.find('.errors .represents-itself').toggleClass('hidden', !personRepresentsItself)
      @$el.find('.errors .cant-be-the-obligee').toggleClass('hidden', !personIsTheObligee)

  updateRepresented: (personData) =>
    data = { applicant: { represented_person: personData } }
    callback = => @audience.set('editingRepresented', false)
    @audience.submitEdition(data, callback)