class audiencias.views.Searcher extends Backbone.View
  id: 'searcher'
  className: 'main-container'
  template: JST["backbone/templates/search/searcher"]

  initialize: ->
    @linkCreator = audiencias.app.linkCreator

  render: ->
    @$el.html(@template())

    header = new audiencias.views.SubHeader
    header.render()
    @$el.find('.search-background-filter').append(header.el)

    form = new audiencias.views.SearchForm(linkCreator: @linkCreator)
    form.render()
    @$el.find('.search-background-filter').append(form.el)

    footer = new audiencias.views.ExternalFooter
    footer.render()
    @$el.find('.with-external-footer').append(footer.el)

    if audiencias.globals.results
      results = new audiencias.views.ResultsList(linkCreator: @linkCreator)
      results.render()
      @$el.find('.with-external-footer').append(results.el)
    else
      shortcuts = new audiencias.views.SearchShortcuts(linkCreator: @linkCreator)
      shortcuts.render()
      @$el.find('.with-external-footer').append(shortcuts.el)
  
      if audiencias.globals.singleAudience 
        historic = !!audiencias.globals.singleAudience.id_audiencia
        fullResult = new audiencias.views.FullResult(audience: audiencias.globals.singleAudience, historic: historic)
        fullResult.render()
        $('body').addClass('showing-full-audience').append(fullResult.el)