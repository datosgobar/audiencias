class audiencias.views.ShortcutsDependencies extends Backbone.View
  className: 'shortcuts-table'
  navigationTemplate: JST["backbone/templates/search/shortcuts_dependencies_navigation"]
  template: JST["backbone/templates/search/shortcuts_dependencies"]
  events: 
    'click img': 'toggleDependency'
    'click .toggle-dependencies': 'toggleDependencies'

  render: ->
    @joinDependenciesAndAggregations()
    @$el.html(@navigationTemplate())
    @$el.append(@template(
      nodes: @dependenciesByParent[0],
      allNodes: @dependenciesByParent
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