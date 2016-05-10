class audiencias.views.DependenciesNavigation extends Backbone.View
  id: 'navigation'
  template: JST["backbone/templates/admin/dependencies/navigation"]
  events:
    'click #supervisor-menu-button': 'triggerShowMenu'
    'click #collapse-all': 'collapseAll'
    'click #expand-all': 'expandAll'
    'input #dependencies-search-input': 'lunrSearch'

  initialize: =>
    @dependencies = audiencias.globals.dependencies.plain
    @initializeLunr()

  render: ->
    @$el.html(@template())

  triggerShowMenu: ->
    $(window).trigger('menu:show-supervisor')

  collapseAll: ->
    $(window).trigger('collapse-all-dependencies')

  expandAll: ->
    $(window).trigger('expand-all-dependencies')

  initializeLunr: =>
    @lunr = lunr( ->
      this.field('name')
      this.ref('index')
    )
    for dependency, index in @dependencies
      dependency.index = index
      @lunr.add(dependency)

  lunrSearch: (e) =>
    searchText = $(e.currentTarget).val().trim()
    
    if searchText.length > 0 
      lunrResults = @lunr.search(searchText)
      results = []
      for lunrResult in lunrResults
        results.push(@dependencies[lunrResult.ref])
      $(window).trigger('search:show-results-list', [results])
    else 
      $(window).trigger('search:show-full-list')