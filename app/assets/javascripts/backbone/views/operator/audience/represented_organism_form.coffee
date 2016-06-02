class audiencias.views.AudienceRepresentedOrganismForm extends Backbone.View
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
    data = { 
      audience: { 
        id: @audience.get('id'),
        applicant: { represented_state_organism: organismData } 
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
