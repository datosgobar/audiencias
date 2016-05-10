#= require ./user_list
class audiencias.views.AdminList extends audiencias.views.UserList
  className: 'hidden'
    
  initialize: ->
    @title = 'Administradores'