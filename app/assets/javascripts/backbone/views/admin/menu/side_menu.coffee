class audiencias.views.SideMenu extends Backbone.View
  id: 'side-menu-container'
  template: JST["backbone/templates/admin/menu/side_menu"]

  initialize: ->
    $(window).on('menu:show-supervisor', @showSupervisorMenu)
    $(window).on('dependency-selected', @showDependencyMenu)
    $(window).on('add-new-dependency', @showNewDependencyMenu)

  render: ->
    @$el.html('<div id="side-menu" class="hidden"></div>')

  showSupervisorMenu: =>
    @render()
    @supervisorMenu = new audiencias.views.SupervisorMenu
    @supervisorMenu.render()
    @$el.find('#side-menu')
      .removeClass('hidden')
      .html(@supervisorMenu.el)

  showDependencyMenu: (e, dependencyId) =>
    @render()
    @dependencyMenu = new audiencias.views.DependencyMenu(dependencyId)
    @dependencyMenu.render()
    @$el.find('#side-menu')
      .removeClass('hidden')
      .append(@dependencyMenu.el)

  showNewDependencyMenu: (e, parentDependencyId) =>
    @newDependencyMenu = new audiencias.views.NewDependencyMenu(parentDependencyId)
    @newDependencyMenu.render()
    @render()
    @$el.find('#side-menu')
      .removeClass('hidden')
      .append(@newDependencyMenu.el)
