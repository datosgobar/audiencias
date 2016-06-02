class audiencias.views.AudienceRepresentedOrganismForm extends Backbone.View
  template: JST["backbone/templates/operator/audience/represented_organism_form"]
  events:
    'change .nationality-radio': 'nationalityChange'

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

