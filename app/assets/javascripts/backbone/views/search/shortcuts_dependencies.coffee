class audiencias.views.ShortcutsDependencies extends Backbone.View
  className: 'shortcuts-table'
  template: JST["backbone/templates/search/shortcuts_dependencies"]
  events: 
    'click img': 'toggleDependency'

  render: ->
    @joinDependenciesAndAggregations()

    @$el.html(@template(
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