class window.AdminDependencyEditor

  constructor: (@dependencies) ->
    @listenEvents()

  listenEvents: ->
    $(window).on('dependency:selected', @showDependencyMenu)

  showDependencyMenu: (e, dependencyId) ->
    $('#admin-menu').addClass('hidden')
    dependency = _.find(@dependencies, (d) -> d.id == dependencyId ) 
    $('#dependencies-menu').removeClass('hidden').text(dependency.name)