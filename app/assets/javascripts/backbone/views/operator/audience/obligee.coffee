class audiencias.views.AudienceObligeeSection extends Backbone.View
  template: JST["backbone/templates/operator/audience/obligee"]

  initialize: (@audience) ->

  render: ->
    @$el.html(@template(
      audience: @audience
    ))