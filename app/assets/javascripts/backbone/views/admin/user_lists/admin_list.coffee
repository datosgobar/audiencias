#= require ./user_list
class audiencias.views.AdminList extends audiencias.views.UserList
  className: 'user-list hidden'
    
  initialize: ->
    @title = 'Administradores'

  toggleShow: =>
    @$el.toggleClass('hidden')