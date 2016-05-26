class audiencias.views.AudienceParticipantsSection extends Backbone.View
  template: JST["backbone/templates/operator/audience/participants"]

  initialize: (@audience) ->

  render: ->
    @$el.html(@template(
      audience: @audience
    ))