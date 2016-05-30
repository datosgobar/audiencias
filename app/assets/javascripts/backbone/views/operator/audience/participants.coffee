class audiencias.views.AudienceParticipantsSection extends Backbone.View
  template: JST["backbone/templates/operator/audience/participants"]

  initialize: (@options) ->
    @audience = @options.audience

  render: ->
    @$el.html(@template(
      audience: @audience
    ))