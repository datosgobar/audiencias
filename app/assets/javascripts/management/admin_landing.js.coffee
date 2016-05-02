class window.AdminLanding

  constructor: (dependencies) ->
    @searcher = new window.AdminSearch(dependencies)
    @results = new window.AdminDependenciesList(dependencies)
    @dependencyEditor = new window.AdminDependencyEditor(dependencies)
    @adminEditor = new window.AdminEditor
