class audiencias.views.NotFound extends Backbone.View
  id: 'not-found'
  className: 'main-container'
  template: JST["backbone/templates/errors/not_found"]

  render: ->
    @$el.html(@template())
    footer = new audiencias.views.ExternalFooter
    footer.render()
    @$el.find('.with-external-footer').append(footer.el)
