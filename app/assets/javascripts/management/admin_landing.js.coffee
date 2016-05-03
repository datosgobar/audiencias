class window.AdminLanding

  constructor: (dependencies) ->
    new window.AdminSearch(dependencies)
    new window.AdminDependenciesList(dependencies)
    new window.AdminDependencyEditor(dependencies)
    new window.AdminList
