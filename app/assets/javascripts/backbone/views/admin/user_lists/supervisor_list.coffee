#= require ./user_list
class audiencias.views.SupervisorList extends audiencias.views.UserList
  title: 'Supervisores'
  
  userFilter: (u) -> 
    u.get('role') == 'superadmin'

  submitNewUser: (user) ->
    $.ajax(
      url: '/intranet/nuevo_supervisor'
      data: { user: user.attributes }
      method: 'POST'
      success: (response) ->
        if response and response.user
          audiencias.globals.users.add(response.user)
    )

  submitChanges: =>
    requests = []
    usersForUpdate = audiencias.globals.users.filter( (user) -> user.get('markedForUpdate' ))
    usersForUpdate.forEach( (user) ->
      requests.push($.ajax(
        url: '/intranet/actualizar_usuario'
        data: { user: user.attributes }
        method: 'POST'
        success: (response) ->
          if response and response.user 
            user.set(response.user)
      ))
    )
    usersForRemoval = audiencias.globals.users.filter( (user) -> user.get('markedForRemoval' ))
    usersForRemoval.forEach( (user) ->
      requests.push($.ajax(
        url: '/intranet/eliminar_supervisor'
        data: { user: user.attributes } 
        method: 'POST'
        success: (response) ->
          if response and response.user 
            user.set(response.user)
      ))
    )