class audiencias.views.SideMenu extends Backbone.View
  id: 'side-menu-container'
  template: JST["backbone/templates/admin/menu/side_menu"]

  initialize: ->
    @supervisorMenu = new audiencias.views.SupervisorMenu
    @dependencyMenu = new audiencias.views.DependencyMenu
    @newDependencyMenu = new audiencias.views.NewDependencyMenu
    @listenWindowEvents()

  listenWindowEvents: ->
    $(window).on('menu:show-supervisor', @showSupervisorMenu)
    $(window).on('dependency-selected', @showDependencyMenu)
    $(window).on('add-new-dependency', @showNewDependencyMenu)

  render: ->
    @$el.html(@template())

    @$el.find('#side-menu').html(@supervisorMenu.el)
      .append(@dependencyMenu.el)
      .append(@newDependencyMenu.el)

  showSupervisorMenu: =>
    @$el.find('#side-menu').removeClass('hidden')
    @$el.find('#supervisor-menu').removeClass('hidden')
      .siblings().addClass('hidden')
    @supervisorMenu.render()

  showDependencyMenu: (e, dependency) =>
    @$el.find('#side-menu').removeClass('hidden')
    @$el.find('#dependency-menu').removeClass('hidden')
      .siblings().addClass('hidden')
    @dependencyMenu.setDependency(dependency)
    @dependencyMenu.render()

  showNewDependencyMenu: (e, parentDependency) =>
    @$el.find('#side-menu').removeClass('hidden')
    @$el.find('#new-dependency-menu').removeClass('hidden')
      .siblings().addClass('hidden')
    @newDependencyMenu.render()