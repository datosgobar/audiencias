class audiencias.views.AudienceApplicantForm extends audiencias.views.Form
  template: JST["backbone/templates/operator/audience/applicant_form"]
  events: 
    'change .nationality-radio': 'nationalityChanged'
    'click .confirm-save': 'verifyForm'
    'autocompleteperson .person-id-input': 'onPersonAutocompleteSelected'
    'autocompleteremoved .person-id-input': 'onPersonAutocompleteRemoved'

  initialize: (@options) ->
    @audience = @options.audience

  render: =>
    @$el.html(@template(audience: @audience))
    new audiencias.views.Tooltip(
      el: @$el.find('.tooltip')
      content: "Solicite primero el pasaporte, de no contar con este solicite id."
    )
    @setPersonAutoComplete('.person-id-input')
    @setMaxLength()

  onPersonAutocompleteSelected: (e, person) =>
    @$el.find('.name-input').val(person.name).prop('disabled', true)

  onPersonAutocompleteRemoved: =>
    @$el.find('.name-input').prop('disabled', false).val('')

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
    
    personIdValid = @validatePersonId(personAttr.person_id, personAttr.country)
    personAlsoParticipant = _.collect(@audience.get('participants'), (p) -> p.person.person_id).indexOf(personAttr.person_id) > -1
    personRepresentsItself = (@audience.get('applicant') and @audience.get('applicant').get('represented_person') and @audience.get('applicant').get('represented_person').person_id == personAttr.person_id)
    personIsTheObligee = (@audience.get('obligee').get('person').person_id == personAttr.person_id) 
    valid = valid and personIdValid and !personAlsoParticipant and !personRepresentsItself and !personIsTheObligee
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
    else 
      @$el.find('.errors .person-also-participant').toggleClass('hidden', !personAlsoParticipant)
      @$el.find('.errors .represents-itself').toggleClass('hidden', !personRepresentsItself)
      @$el.find('.errors .cant-be-the-obligee').toggleClass('hidden', !personIsTheObligee)

  updateApplicant: (applicantData) =>
    data = { applicant: applicantData }
    callback = => @audience.set('editingApplicant', false)
    @audience.submitEdition(data, callback)