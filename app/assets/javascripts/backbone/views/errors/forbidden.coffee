class audiencias.views.Forbidden extends Backbone.View
  id: 'forbidden'
  className: 'main-container'
  template: JST["backbone/templates/errors/forbidden"]

  render: ->
    @$el.html(@template())
    footer = new audiencias.views.ExternalFooter
    footer.render()
    @$el.find('.with-external-footer').append(footer.el)
