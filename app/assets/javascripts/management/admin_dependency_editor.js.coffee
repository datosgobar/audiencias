class window.AdminDependencyEditor

  constructor: (@dependencies) ->
    @listenEvents()

  listenEvents: ->
    $(window).on('dependency:selected', @showDependencyMenu)
    $('#dependencies-tree .add-new-dependency').on('click', @showNewDependencyForm)

  showDependencyMenu: (e, dependencyId) ->
    $('#admin-menu').addClass('hidden')
    dependency = _.find(@dependencies, (d) -> d.id == dependencyId ) 
    $('#dependencies-menu').removeClass('hidden').text(dependency.name)

  showNewDependencyForm: ->
    $('#admin-menu').addClass('hidden')
    $('#dependencies-menu').removeClass('hidden')