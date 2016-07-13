class audiencias.views.Searcher extends Backbone.View
  id: 'searcher'
  className: 'main-container'
  template: JST["backbone/templates/search/searcher"]

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
      shortcuts = new audiencias.views.SearchShortcuts
      shortcuts.render()
      @$el.find('.with-external-footer').append(shortcuts.el)
  
      if audiencias.globals.singleAudience 
        console.log('asd')
        fullResult = new audiencias.views.FullResult(audience: audiencias.globals.singleAudience)
        fullResult.render()
        $('body').append(fullResult.el)

  linkCreator: (newParams) ->
    paramList = []
    searchOptions = $.extend({}, audiencias.globals.results.options)
    searchOptions = $.extend(searchOptions, newParams)
    for key of searchOptions
      paramList.push("#{key}=#{searchOptions[key]}") if searchOptions[key]
    params = if paramList.length > 0 then '?' + paramList.join('&') else ''
    "/buscar#{params}"