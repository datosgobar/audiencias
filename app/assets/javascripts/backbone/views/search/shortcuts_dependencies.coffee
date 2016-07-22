class audiencias.views.ShortcutsDependencies extends Backbone.View
  navigationTemplate: JST["backbone/templates/search/shortcuts_dependencies_navigation"]
  template: JST["backbone/templates/search/shortcuts_dependencies"]
  events: 
    'click img': 'toggleDependency'
    'click .toggle-dependencies': 'toggleDependencies'
    'input .dependency-input-search': 'lunrSearch'

  initialize: ->
    @joinDependenciesAndAggregations()
    @initializeLunr()

  initializeLunr: ->
    @lunr = lunr( ->
      this.field('name')
      this.ref('id')
    )
    dependencies = audiencias.globals.dependencies_shortcuts
    @lunr.add(dependency) for dependency in dependencies

  lunrSearch: (e) =>
    searchText = $(e.currentTarget).val().trim()
    if searchText.length > 0 
      lunrResults = @lunr.search(searchText)
      if lunrResults.length > 0
        dependenciesIds = _.pluck(lunrResults, 'ref')
        dependencies = _.filter(audiencias.globals.dependencies_shortcuts, (d) -> dependenciesIds.indexOf(d.id) > -1)
        @renderResults(dependencies)
      else
        @renderResults([])
    else 
      @renderTree()

  render: ->
    @$el.html(@navigationTemplate())
    @renderTree()

  renderTree: ->
    @$el.find('.shortcuts-table').html(@template(
      nodes: @dependenciesByParent[0],
      allNodes: @dependenciesByParent
      padding: 0,
      template: @template,
      aggregations: @aggregationsById
    ))

  renderResults: (results) ->
    @$el.find('.shortcuts-table').html(@template(
      nodes: results,
      allNodes: []
      padding: 0,
      template: @template,
      aggregations: @aggregationsById
    ))

  joinDependenciesAndAggregations: ->
    flatAggregations = audiencias.globals.aggregations._dependency.ids.buckets
    @aggregationsById = []
    _.map(flatAggregations, (a) => @aggregationsById[a.key] = a)

    flatDependencies = audiencias.globals.dependencies_shortcuts
    @dependenciesByParent = _.groupBy(flatDependencies, (d) => 
      d.count = if @aggregationsById[d.id] then @aggregationsById[d.id].doc_count else 0
      if !!d.parent_id then d.parent_id else 0
    )

  toggleDependency: (e) ->
    e.preventDefault()
    target = $(e.currentTarget)
    target.parents('.dependency').toggleClass('selected')

  toggleDependencies: (e) ->
    target = $(e.currentTarget)
    if target.attr('id') == 'expand-all'
      @$el.find('.dependency').toggleClass('selected')
    else
      @$el.find('.dependency').toggleClass('selected')
    @$el.find('.toggle-dependencies').toggleClass('hidden')