class audiencias.views.SubHeader extends Backbone.View
  className: 'subheader-container'
  template: JST["backbone/templates/search/subheader"]

  render: ->
    @$el.html(@template())
