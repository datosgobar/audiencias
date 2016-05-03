class window.AdminLanding

  constructor: (dependencies) ->
    new window.DependencySearcher(dependencies)
    new window.DependenciesList(dependencies)
    new window.DependencyMenu(dependencies)
    new window.AdminMenu
    new window.ImportantMessage