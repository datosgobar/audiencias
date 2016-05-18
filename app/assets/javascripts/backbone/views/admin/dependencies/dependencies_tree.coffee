class audiencias.views.DependenciesTree extends Backbone.View
  id: 'dependencies'
  containerTemplate: JST["backbone/templates/admin/dependencies/list_container"]
  treeTemplate: JST["backbone/templates/admin/dependencies/tree"]
  resultsTemplate: JST["backbone/templates/admin/dependencies/search_results"]
  events: 
    'click #dependencies-tree .dependency': 'selectDependency'
    'click #dependencies-results .dependency': 'selectDependency'
  
  initialize: ->
    $(window).on('search:show-full-list', @showFullList)
      .on('search:show-results-list', @showResultsList)
    audiencias.globals.userDependencies.on('change add remove', @render)
    @mode = 'tree'

  render: =>
    @$el.html(@containerTemplate())
    if @mode == 'tree'
      dependenciesTree = @treeTemplate({
        nodes: audiencias.globals.userDependencies.filter( (d) -> d.get('top') or not d.get('parent_id') ),
        padding: 12.5,
        template: @treeTemplate
      })
      @$el.find('#dependencies-tree').html(dependenciesTree)
    else
      resultsEl = @resultsTemplate({ 
        results: @results, 
      })
      @$el.find('#dependencies-results').html(resultsEl)
    @$el.find('.list-container').nanoScroller(flash: false)

  selectDependency: (event) =>
    id = $(event.currentTarget).data('dependency-id')
    audiencias.globals.userDependencies.setSelected(id)
    $(window).trigger('dependency-selected', [id])

  showFullList: =>
    @mode = 'tree'
    @render()

  showResultsList: (e, results) =>
    @mode = 'results'
    resultsIds = _.collect(results, (r) -> r.ref )
    @results = audiencias.globals.userDependencies.filter((d) -> 
      resultsIds.indexOf(d.get('id')) > -1 
    )
    @render()