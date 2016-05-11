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
    $(window).on('globals:dependencies:loaded', @render)
    @selectedDependency = {}

  render: =>
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
    target = $(e.currentTarget)
    @selectedDependency = @findDependency(target)
    @selectDependencyHighlight()
    if @selectedDependency.children and @selectedDependency.children.length > 0
      target.toggleClass('expanded collapsed')
    @triggerSelect(@selectedDependency)

  resultsSelectDependency: (e) =>
    target = $(e.currentTarget)
    targetId = target.data('dependency-id')
    @selectedDependency = @findDependency(target)
    @selectDependencyHighlight()
    @triggerSelect(@selectedDependency)

  triggerSelect: (dependency) =>
    $(window).trigger('dependency-selected', [dependency])

  selectDependencyHighlight: =>
    @$el.find('.dependency.selected').removeClass('selected')
    @$el.find(".dependency[data-dependency-id='#{@selectedDependency.id}']").addClass('selected')

  findDependency: (el) =>
    id = $(el).data('dependency-id')
    _.find(audiencias.globals.dependencies.plain, (d) -> d.id == id)

  collapseAll: =>
    @$el.find('.dependency.expanded').removeClass('expanded').addClass('collapsed')

  expandAll: =>
    @$el.find('.dependency.collapsed').removeClass('collapsed').addClass('expanded')

  showFullList: =>
    @$el.find('#dependencies-tree').removeClass('hidden')
    @$el.find('#dependencies-results').addClass('hidden')

  showResultsList: (e, results) =>
    @$el.find('#dependencies-tree').addClass('hidden')
    resultsEl = @resultsTemplate({ results: results, selectedDependency: @selectedDependency })
    @$el.find('#dependencies-results').removeClass('hidden').html(resultsEl)
