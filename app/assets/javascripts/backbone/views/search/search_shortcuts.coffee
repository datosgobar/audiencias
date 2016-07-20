class audiencias.views.SearchShortcuts extends Backbone.View
  className: 'shortcuts'
  template: JST["backbone/templates/search/shortcuts"]

  initialize: (options) ->
    @linkCreator = options.linkCreator

  render: ->
    @$el.html(@template(linkCreator: @linkCreator))