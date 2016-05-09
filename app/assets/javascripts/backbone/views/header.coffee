class audiencias.views.Header extends Backbone.View
  id: 'header'
  template: JST["backbone/templates/header"]
  events: 
    'click #user-header': 'toggleShowMenu'
    'click #logout': 'logout'

  render: ->
    @$el.html(@template())

  toggleShowMenu: ->
    userMenu = $('#user-menu')
    userMenuIcon = $('#user-header-icon')
    if userMenu.hasClass('user-menu-visible')
      userMenu.css('bottom', '')
      userMenu.removeClass('user-menu-visible')
      userMenuIcon.removeClass('user-menu-visible')
    else
      userMenu.css('bottom', -userMenu.outerHeight())
      userMenu.addClass('user-menu-visible')
      userMenuIcon.addClass('user-menu-visible')

  logout: ->
    window.location.replace('/salir')