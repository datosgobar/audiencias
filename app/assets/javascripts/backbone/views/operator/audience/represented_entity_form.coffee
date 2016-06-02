class audiencias.views.AudienceRepresentedEntityForm extends Backbone.View
  template: JST["backbone/templates/operator/audience/represented_entity_form"]
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
    represented = @applicant.get('represented_legal_entity')
    represented.country = newCountry
    @applicant.set('represented_legal_entity', represented)
    @render()

