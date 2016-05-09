class audiencias.views.SideMenu extends Backbone.View
  id: 'side-menu-container'
  template: JST["backbone/templates/admin/side_menu"]

  initialize: ->
    @supervisorMenu = new audiencias.views.SupervisorMenu
    @listenWindowEvents()

  listenWindowEvents: ->
    $(window).on('menu:show-supervisor', @showSupervisorMenu)

  render: ->
    @$el.html(@template())

    @supervisorMenu.render()

    @$el.find('#side-menu').html(@supervisorMenu.el)

  showSupervisorMenu: =>
    @$el.find('#side-menu').removeClass('hidden')
    @supervisorMenu.show()
