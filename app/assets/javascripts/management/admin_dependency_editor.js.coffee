class window.AdminDependencyEditor

  constructor: ->


  showMenu: (dependencyId) ->
    dependency = _.find(@dependencies, (d) -> d.id == dependencyId ) 
    $('#dependencies-menu').text(dependency.name)