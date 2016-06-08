class audiencias.views.Footer extends Backbone.View
  id: 'intranet-footer'
  template: JST["backbone/templates/footer"]

  render: ->
    @$el.html(@template())