class audiencias.views.SideMenu extends Backbone.View
  id: 'side-menu-container'
  template: JST["backbone/templates/admin/menu/side_menu"]

  initialize: ->
    $(window).on('menu:show-supervisor', @showSupervisorMenu)
      .on('dependency-selected', @showDependencyMenu)
      .on('add-new-dependency', @showNewDependencyMenu)
      .on('hide-side-menu', @hideSideMenu)
      
  render: ->
    @$el.html(@template())
    @$el.find('#side-menu').on('click', @updateScroll)
    @cancelAll()

  updateScroll: =>
    @$el.find('.nano').nanoScroller()

  showSupervisorMenu: =>
    @render()
    @supervisorMenu = new audiencias.views.SupervisorMenu
    @supervisorMenu.render()
    @$el.find('#side-menu').removeClass('hidden')
    @$el.find('.nano-content').html(@supervisorMenu.el)
    @updateScroll()
    audiencias.globals.userDependencies.deselectAll()

  showDependencyMenu: (e, dependencyId) =>
    @render()
    @dependencyMenu = new audiencias.views.DependencyMenu(dependencyId)
    @dependencyMenu.render()
    @$el.find('#side-menu').removeClass('hidden')
    @$el.find('.nano-content').append(@dependencyMenu.el)
    @updateScroll()

  showNewDependencyMenu: (e, parentDependencyId) =>
    @render()
    @newDependencyMenu = new audiencias.views.NewDependencyMenu(parentId: parentDependencyId)
    @newDependencyMenu.render()
    @$el.find('#side-menu').removeClass('hidden')
    @$el.find('.nano-content').append(@newDependencyMenu.el)
    @updateScroll()

  hideSideMenu: =>
    @$el.find('#side-menu').addClass('hidden')

  cancelAll: =>
    @supervisorMenu.cancelEdition() if @supervisorMenu
    @dependencyMenu.cancelEdition() if @dependencyMenu
    @newDependencyMenu.cancelNewDependency() if @newDependencyMenu