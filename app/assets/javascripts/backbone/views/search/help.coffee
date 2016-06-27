class audiencias.views.Help extends Backbone.View
  id: 'help'
  className: 'main-container'
  template: JST["backbone/templates/search/help"]

  render: ->
    @$el.html(@template())

    header = new audiencias.views.SubHeader
    header.render()
    @$el.find('.search-background-filter').prepend(header.el)

    footer = new audiencias.views.ExternalFooter
    footer.render()
    @$el.find('.with-external-footer').append(footer.el)