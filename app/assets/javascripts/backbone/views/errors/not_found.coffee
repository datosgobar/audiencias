class audiencias.views.NotFound extends Backbone.View
  id: 'not-found'
  className: 'error-layout'
  template: JST["backbone/templates/errors/not_found"]

  render: ->
    @$el.html(@template())
