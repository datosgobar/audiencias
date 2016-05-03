class window.DependencySearcher

  constructor: (@dependencies) ->
    @initializeLunr()
    @listenEvents()

  initializeLunr: ->
    @lunr = lunr( ->
      this.field('name')
      this.ref('index')
    )
    for dependency, index in @dependencies
      dependency.index = index
      @lunr.add(dependency)

  listenEvents: ->
    $('#search-text').on('input', @lunrSearch)

  lunrSearch: (e) =>
    searchText = $(e.currentTarget).val().trim()
    
    if searchText.length > 0 
      lunrResults = @lunr.search(searchText)
      results = []
      for lunrResult in lunrResults
        results.push(@dependencies[lunrResult.ref])
      $(window).trigger('search:show-results', [results])
    else 
      $(window).trigger('search:show-base-list')
