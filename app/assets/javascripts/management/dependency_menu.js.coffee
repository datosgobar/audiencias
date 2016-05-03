class window.DependencyMenu extends window.AbstractMenu

  constructor: (@dependencies) ->
    @menuId = '#dependencies-menu'
    @listenEvents()

  listenEvents: ->
    $(window).on('dependency:selected', @selectDependency)
    $('#dependencies-tree .add-new-dependency').on('click', @showNewDependencyForm)
    $('#admin-menu #add-dependency').on('click', @showNewDependencyForm)
    $('#add-sub-dependency').on('click', @showNewDependencyForm)
    $('#see-current-dependency-admin').on('click', @showAdmin)
    $('#hide-current-dependency-admin').on('click', @hideAdmin)
    $('#dependencies-menu .cancel-top-action .cancel').on('click', @showDefault)

  selectDependency: (e, dependencyId) =>
    dependency = _.find(@dependencies, (d) -> d.id == dependencyId ) 
    @currentDependency = dependency
    @showDefault()

  showDefault: =>
    $('#admin-menu').addClass('hidden')
    $('#dependencies-menu').removeClass('hidden')
    @showTopMenu()
    @hideAdmin()
    @showCurrentAdminButton()
    $('#dependencies-menu .title-text').text(@currentDependency.name)

  showNewDependencyForm: =>
    @showCancelAction()
    $('#admin-menu').addClass('hidden')
    $('#dependencies-menu').removeClass('hidden')

  showAdmin: =>
    @showCurrentAdmin()
    @hideCurrentAdminButton()

  hideAdmin: =>
    @hideCurrentAdmin()
    @showCurrentAdminButton()

  showCurrentAdmin: =>
    $('#current-dependency-admin').removeClass('hidden')

  hideCurrentAdmin: =>
    $('#current-dependency-admin').addClass('hidden')

  hideCurrentAdminButton: =>
    $('#see-current-dependency-admin').addClass('hidden')
    $('#hide-current-dependency-admin').removeClass('hidden')

  showCurrentAdminButton: =>
    $('#see-current-dependency-admin').removeClass('hidden')
    $('#hide-current-dependency-admin').addClass('hidden')