class audiencias.views.Forbidden extends Backbone.View
  id: 'forbidden'
  className: 'error-layout with-external-footer'
  template: JST["backbone/templates/errors/forbidden"]

  render: ->
    @$el.html(@template())
