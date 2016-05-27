class audiencias.views.Header extends Backbone.View
  id: 'header'
  template: JST["backbone/templates/header"]
  events: 
    'click #user-header': 'toggleShowMenu'
    'click #logout': 'logout'

  initialize: ->
    audiencias.globals.users.on('add change', @render)

  render: =>
    @$el.html(@template())

  toggleShowMenu: (evt) =>
    if evt
      evt.preventDefault()
      evt.stopImmediatePropagation()

    userMenu = @$el.find('#user-menu')
    userMenuIcon = @$el.find('#user-header-icon')
    if userMenu.hasClass('user-menu-visible')
      userMenu.css('bottom', '')
      userMenu.removeClass('user-menu-visible')
      userMenuIcon.removeClass('user-menu-visible')
    else
      userMenu.css('bottom', -userMenu.outerHeight())
      userMenu.addClass('user-menu-visible')
      userMenuIcon.addClass('user-menu-visible')
      @listenForOneOutsideClick()
      

  logout: ->
    window.location.replace('/salir')

  listenForOneOutsideClick: =>
    $(window).one('click', (e) => 
      clickedOnUser = $(e.target).attr('id') == 'user-header'
      clickedOnUserChild = $(e.target).parents('#user-header').length > 0
      clickedOutside = not clickedOnUser and not clickedOnUserChild
      menuVisible = @$el.find('#user-menu').hasClass('user-menu-visible')
      if clickedOutside and menuVisible
        @toggleShowMenu() 
    )