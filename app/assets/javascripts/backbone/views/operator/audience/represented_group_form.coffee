class audiencias.views.AudienceRepresentedGroupForm extends Backbone.View
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
    @setDescriptionfMaxLength()

  nationalityChange: =>
    newCountry = @$el.find('.nationality-radio:checked').val()
    represented = @applicant.get('represented_people_group')
    represented.country = newCountry
    @applicant.set('represented_people_group', represented)
    @render()

  setDescriptionfMaxLength: =>
    descriptionTextarea = @$el.find('#group-description')
    descriptionTextarea.bind('input propertychange', =>
      maxLength = descriptionTextarea.attr('maxlength')
      if descriptionTextarea.val().length > maxLength
        cuttedText = descriptionTextarea.val().substring(0, maxLength)
        descriptionTextarea.val(cuttedText)
    )

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
    data = { 
      audience: { 
        id: @audience.get('id'),
        applicant: { represented_people_group: groupData } 
      } 
    }
    $.ajax(
      url: '/intranet/editar_audiencia'
      method: 'POST'
      data: data
      success: (response) =>
        if response.success and response.audience
            response.audience.editingRepresented = false
            @audience.forceUpdate(response.audience)
    )

  validateCountry: (country) ->
    country == 'Argentina' or audiencias.globals.countries.indexOf(country) > -1

  validateName: (name) ->
    name.trim().length > 0 

  validateEmail: (email) ->
    /[\w+\-.]+@[a-z\d\-.]+\.[a-z]+/i.test(email)