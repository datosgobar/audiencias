class audiencias.views.Searcher extends Backbone.View
  id: 'searcher'
  className: 'main-container'
  template: JST["backbone/templates/search/searcher"]

  render: ->
    @$el.html(@template())

    header = new audiencias.views.SubHeader
    header.render()
    @$el.find('.search-background-filter').prepend(header.el)

    footer = new audiencias.views.ExternalFooter
    footer.render()
    @$el.find('.with-external-footer').append(footer.el)
