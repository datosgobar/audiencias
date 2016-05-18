#= require ./user_list
class audiencias.views.OperatorList extends audiencias.views.UserList
  title: 'Operadores'
  confirmNewUserText:
    main: '¿Está seguro de que desea dar permisos de operador al usuario?',
    secondary: 'El usuario podrá gestionar las audiencias del actual sujeto obligado.'
    
  initialize: (options) ->
    super(options)
    @dependency = options.dependency

  render: =>
    return unless @dependency.get('obligee')
    super()

  userFilter: (u) => 
    obligee = @dependency.get('obligee')
    if obligee
      operatorsIds = _.collect(obligee.users, (a) -> a.id)
      operatorsIds.indexOf(u.get('id')) > -1
    else 
      false

  submitNewUser: (user) ->
    $.ajax(
      url: '/intranet/nuevo_operador'
      data: { user: user.attributes, dependency: @dependency.attributes }
      method: 'POST'
      success: (response) ->
        if response and response.user
          audiencias.globals.users.updateUser(response.user)
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
            audiencias.globals.users.updateUser(response.user)
      ))
    )
    usersForRemoval = audiencias.globals.users.filter( (user) -> user.get('markedForRemoval' ))
    usersForRemoval.forEach( (user) =>
      requests.push($.ajax(
        url: '/intranet/eliminar_operador'
        data: { user: user.attributes, dependency: @dependency.attributes } 
        method: 'POST'
        success: (response) ->
          if response and response.user 
            audiencias.globals.users.updateUser(response.user)
          if response and response.dependency
            audiencias.globals.userDependencies.forceUpdate(response.dependency)
      ))
    )