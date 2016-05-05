class Audiencias.Views.Header extends Backbone.View
  id: 'header'
  template: JST["backbone/templates/header"]

  render: ->
    @$el.html(@template())
