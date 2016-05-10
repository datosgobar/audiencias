class audiencias.views.SideMenu extends Backbone.View
  id: 'side-menu-container'
  template: JST["backbone/templates/admin/menu/side_menu"]

  initialize: ->
    @supervisorMenu = new audiencias.views.SupervisorMenu
    @dependencyMenu = new audiencias.views.DependencyMenu
    @listenWindowEvents()

  listenWindowEvents: ->
    $(window).on('menu:show-supervisor', @showSupervisorMenu)
    $(window).on('dependency-selected', @showDependencyMenu)

  render: ->
    @$el.html(@template())

    @dependencyMenu.render()
    @supervisorMenu.render()

    @$el.find('#side-menu').html(@supervisorMenu.el)
    @$el.find('#side-menu').append(@dependencyMenu.el)

  showSupervisorMenu: =>
    @$el.find('#side-menu').removeClass('hidden')
    @$el.find('#supervisor-menu').removeClass('hidden')
    @$el.find('#dependency-menu').addClass('hidden')
    @supervisorMenu.defaultView()

  showDependencyMenu: (e, dependency) =>
    @$el.find('#side-menu').removeClass('hidden')
    @$el.find('#supervisor-menu').addClass('hidden')
    @$el.find('#dependency-menu').removeClass('hidden')
    @dependencyMenu.defaultView(dependency)