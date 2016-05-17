#= require ./user_list
class audiencias.views.AdminList extends audiencias.views.UserList
  title: 'Administradores'

  initialize: (options) ->
    super(options)
    @dependency = options.dependency

  userFilter: (u) => 
    dependencyAdmins = @dependency.get('users')
    adminsIds = _.collect(dependencyAdmins, (a) -> a.id)
    adminsIds.indexOf(u.get('id')) > -1

  submitNewUser: (user) ->
    $.ajax(
      url: '/intranet/nuevo_administrador'
      data: { user: user.attributes, dependency: @dependency.attributes }
      method: 'POST'
      success: (response) ->
        if response and response.user
          audiencias.globals.users.add(response.user)
        if response and response.dependency
          audiencias.globals.userDependencies.forceUpdate(response.dependency)
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
    usersForRemoval.forEach( (user) =>
      requests.push($.ajax(
        url: '/intranet/eliminar_administrador'
        data: { user: user.attributes, dependency: @dependency.attributes } 
        method: 'POST'
        success: (response) ->
          if response and response.user 
            user.set(response.user)
          if response and response.dependency
            audiencias.globals.userDependencies.forceUpdate(response.dependency)
      ))
    )
