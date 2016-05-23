class audiencias.views.OperatorAudiences extends Backbone.View
  id: 'operator-audiences'
  template: JST["backbone/templates/operator/operator_audiences"]

  render: ->
    @$el.html(@template())