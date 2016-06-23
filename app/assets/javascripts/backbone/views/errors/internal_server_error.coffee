class audiencias.views.InternalServerError extends Backbone.View
  id: 'internal-server-error'
  className: 'main-container'
  template: JST["backbone/templates/errors/internal_server_error"]

  render: ->
    @$el.html(@template())
    footer = new audiencias.views.ExternalFooter
    footer.render()
    @$el.find('.with-external-footer').append(footer.el)
