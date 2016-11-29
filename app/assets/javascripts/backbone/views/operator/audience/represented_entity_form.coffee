class audiencias.views.AudienceRepresentedEntityForm extends audiencias.views.Form
  template: JST["backbone/templates/operator/audience/represented_entity_form"]
  events:
    'change .nationality-radio': 'nationalityChange'
    'click .confirm-save': 'validateForm'
    'autocompleteentity .cuit-input': 'onEntityAutocompleteSelected'
    'autocompleteremoved .cuit-input': 'onEntityAutocompleteRemoved'

  initialize: (options) ->
    @audience = options.audience
    @applicant = @audience.get('applicant')

  render: ->
    @$el.html(@template(
      audience: @audience,
      disableNameInput: !@userCanWriteName
    )) 
    new audiencias.views.Tooltip({
      el: @$el.find('.cuit-tooltip')
      content: "Debe ingresar el numero de CUIT sin guiones ni espacios."
    })
    @setEntityAutocomplete('.cuit-input')

  onEntityAutocompleteSelected: (e, entity) =>
    @$el.find('.name-input').val(entity.name).prop('disabled', true)

  onEntityAutocompleteRemoved: =>
    @$el.find('.name-input').val('').prop('disabled', !@userCanWriteName)

  nationalityChange: =>
    newCountry = @$el.find('.nationality-radio:checked').val()
    @userCanWriteName = newCountry != 'Argentina'
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
    data = { applicant: { represented_legal_entity: entityDate } }
    callback = => @audience.set('editingRepresented', false)
    @audience.submitEdition(data, callback)