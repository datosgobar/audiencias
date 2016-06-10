class audiencias.views.AudienceRepresentedGroupForm extends audiencias.views.Form
  template: JST["backbone/templates/operator/audience/represented_group_form"]
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
    @setMaxLength('#group-description')

  nationalityChange: =>
    newCountry = @$el.find('.nationality-radio:checked').val()
    represented = @applicant.get('represented_people_group')
    represented.country = newCountry
    @applicant.set('represented_people_group', represented)
    @render()

  validateForm: =>
    if @$el.find('#represented-nationality-argentine').is(':checked')
      country = 'Argentina'
    else
      country = @$el.find('.countries-select').val()

    groupAttrs = {
      country: country
      name: @$el.find('.name-input').val().trim()
      email: @$el.find('.email-input').val().trim()
      telephone: @$el.find('.telephone-input').val().trim()
      description: @$el.find('#group-description').val().trim()
    }
    valid = true
    
    countryValid = @validateCountry(groupAttrs.country)
    valid = valid and countryValid
    @$el.find('.countries-select').toggleClass('invalid', !countryValid)
        
    nameValid = @validateName(groupAttrs.name)
    valid = valid and nameValid
    @$el.find('.name-input').toggleClass('invalid', !nameValid)
    
    if groupAttrs.email.length > 0
      emailValid = @validateEmail(groupAttrs.email)
      valid = valid and emailValid
      @$el.find('.email-input').toggleClass('invalid', !emailValid)

    if valid
      @updateRepresented(groupAttrs)

  updateRepresented: (groupData) =>
    data = { applicant: { represented_people_group: groupData } }
    callback = => @audience.set('editingRepresented', false)
    @audience.submitEdition(data, callback)