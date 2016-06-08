class audiencias.views.DependenciesNavigation extends Backbone.View
  id: 'navigation'
  template: JST["backbone/templates/admin/dependencies/navigation"]
  events:
    'click #supervisor-menu-button': 'triggerShowMenu'
    'click #collapse-all': 'collapseAll'
    'click #expand-all': 'expandAll'
    'input #dependencies-search-input': 'lunrSearch'

  initialize: =>
    audiencias.globals.userDependencies.on('change add remove', @initializeLunr)
    audiencias.globals.users.on('change add', @render)

  render: =>
    @$el.html(@template())

  triggerShowMenu: ->
    $(window).trigger('menu:show-supervisor')

  collapseAll: ->
    $('#expand-all, #collapse-all').toggleClass('hidden')
    audiencias.globals.userDependencies.forEach (dependency) ->
      dependency.collapse()

  expandAll: ->
    $('#expand-all, #collapse-all').toggleClass('hidden')
    audiencias.globals.userDependencies.forEach (dependency) ->
      dependency.expand()

  initializeLunr: =>
    @lunr = lunr( ->
      this.field('lunrName')
      this.ref('id')
    )
    audiencias.globals.userDependencies.forEach( (dependency) =>
      indexedDependency = {
        id: dependency.get('id')
        lunrName: dependency.get('name')
      }
      if dependency.get('obligee')
        name = dependency.get('obligee').person.name
        indexedDependency.lunrName += " #{name}"
      @lunr.add(indexedDependency)
    )

  lunrSearch: (e) =>
    searchText = $(e.currentTarget).val().trim()
    
    if searchText.length > 0 
      lunrResults = @lunr.search(searchText)
      $(window).trigger('search:show-results-list', [lunrResults])
    else 
      $(window).trigger('search:show-full-list')