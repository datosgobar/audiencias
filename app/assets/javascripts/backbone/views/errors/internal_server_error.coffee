class audiencias.views.InternalServerError extends Backbone.View
  id: 'internal-server-error'
  className: 'error-layout'
  template: JST["backbone/templates/errors/internal_server_error"]

  render: ->
    @$el.html(@template())
