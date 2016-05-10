class audiencias.views.DependenciesTree extends Backbone.View
  id: 'dependencies'
  baseTemplate: JST["backbone/templates/admin/dependencies/dependencies"]
  treeTemplate: JST["backbone/templates/admin/dependencies/tree"]
  resultsTemplate: JST["backbone/templates/admin/dependencies/search_results"]
  events: 
    'click #dependencies-tree .dependency': 'treeSelectDependency'
    'click #dependencies-results .dependency': 'resultsSelectDependency'
  
  initialize: ->
    $(window).on('collapse-all-dependencies', @collapseAll)
    $(window).on('expand-all-dependencies', @expandAll)
    $(window).on('search:show-full-list', @showFullList)
    $(window).on('search:show-results-list', @showResultsList)

  render: ->
    if audiencias.globals.dependencies and audiencias.globals.dependencies.tree
      tree = audiencias.globals.dependencies.tree
      @$el.html(@baseTemplate())
      dependenciesTree = @treeTemplate({
        nodes: tree,
        padding: 12.5,
        template: @treeTemplate
      })
      @$el.find('#dependencies-tree').html(dependenciesTree)

  treeSelectDependency: (e) =>
    @$el.find('.dependency.selected').removeClass('selected')
    target = $(e.currentTarget)
    target.toggleClass('expanded collapsed selected')
    targetId = target.data('dependency-id')
    @selectDependency(targetId)

  resultsSelectDependency: (e) =>
    @$el.find('.dependency.selected').removeClass('selected')
    target = $(e.currentTarget)
    target.toggleClass('selected')
    targetId = target.data('dependency-id')
    @selectDependency(targetId)

  selectDependency: (id) =>
    dependency = _.find(audiencias.globals.dependencies.plain, (d) -> d.id == id)
    $(window).trigger('dependency-selected', [dependency])

  collapseAll: =>
    @$el.find('.dependency.expanded').removeClass('expanded').addClass('collapsed')

  expandAll: =>
    @$el.find('.dependency.collapsed').removeClass('collapsed').addClass('expanded')

  showFullList: =>
    @$el.find('#dependencies-tree').removeClass('hidden')
    @$el.find('#dependencies-results').addClass('hidden')

  showResultsList: (e, results) =>
    @$el.find('#dependencies-tree').addClass('hidden')
    resultsEl = @resultsTemplate({ results: results })
    @$el.find('#dependencies-results').removeClass('hidden').html(resultsEl)
