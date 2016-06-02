class audiencias.views.AudienceRepresentedApplicantForm extends Backbone.View
  template: JST["backbone/templates/operator/audience/represented_person_form"]
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
    represented = @applicant.get('represented_person')
    represented.country = newCountry
    @applicant.set('represented_person', represented)
    @render()

