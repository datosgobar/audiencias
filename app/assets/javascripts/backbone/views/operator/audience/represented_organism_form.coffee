class audiencias.views.AudienceRepresentedOrganismForm extends audiencias.views.Form
  template: JST["backbone/templates/operator/audience/represented_organism_form"]
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
    @setMaxLength()
    @setAutocomplete()

  nationalityChange: =>
    newCountry = @$el.find('.nationality-radio:checked').val()
    represented = @applicant.get('represented_state_organism')
    represented.country = newCountry
    @applicant.set('represented_state_organism', represented)
    @render()

  validateForm: =>
    if @$el.find('#represented-nationality-argentine').is(':checked')
      country = 'Argentina'
    else
      country = @$el.find('.countries-select').val()

    organismAttrs = {
      country: country
      name: @$el.find('.name-input').val().trim()
    }
    valid = true
    
    countryValid = @validateCountry(organismAttrs.country)
    valid = valid and countryValid
    @$el.find('.countries-select').toggleClass('invalid', !countryValid)
        
    nameValid = @validateName(organismAttrs.name)
    valid = valid and nameValid
    @$el.find('.name-input').toggleClass('invalid', !nameValid)

    if valid
      @updateRepresented(organismAttrs)

  updateRepresented: (organismData) =>
    data = { applicant: { represented_state_organism: organismData } }
    callback = => @audience.set('editingRepresented', false)
    @audience.submitEdition(data, callback)

  setAutocomplete: =>
    if @audience.get('applicant').get('represented_state_organism').country == 'Argentina'
      @$el.find('.name-input').autocomplete(
        source: audiencias.globals.dependencyAutocomplete
      )