class audiencias.views.Searcher extends Backbone.View
  id: 'searcher'
  className: 'main-container'
  template: JST["backbone/templates/search/searcher"]

  render: ->
    @$el.html(@template())

    header = new audiencias.views.SubHeader
    header.render()
    @$el.find('.search-background-filter').append(header.el)

    form = new audiencias.views.SearchForm
    form.render()
    @$el.find('.search-background-filter').append(form.el)

    footer = new audiencias.views.ExternalFooter
    footer.render()
    @$el.find('.with-external-footer').append(footer.el)

    if audiencias.globals.results
      results = new audiencias.views.Results
      results.render()
      @$el.find('.with-external-footer').append(results.el)
    else
      shortcuts = new audiencias.views.SearchShortcuts
      shortcuts.render()
      @$el.find('.with-external-footer').append(shortcuts.el)