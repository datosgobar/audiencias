class audiencias.views.OperatorAudiences extends Backbone.View
  id: 'operator-audiences'
  template: JST["backbone/templates/operator/operator_audiences"]

  initialize: ->
    audiencias.globals.audiences.on('add change', @render)

  render: =>
    @$el.html(@template(
      audiences: JSON.parse(JSON.stringify(audiencias.globals.audiences))
    ))