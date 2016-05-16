#= require ./user_list
class audiencias.views.OperatorList extends audiencias.views.UserList
  title: 'Operadores'

  initialize: (dependency) ->
    super()
    @dependency = dependency
    @obligee = dependency.obligee
    if @obligee and @obligee.users
      @users = @obligee.users
    else 
      @users = []

  render: ->
    super() if @obligee

  addUserFromForm: =>
    validation = @validateUser('.new-user-form')
    if validation.valid
      userData = validation.data
      dependencyData = { id: @dependency.id }
      messageOptions = {
        icon: 'alert',
        confirmation: true,
        text: {
          main: '¿Está seguro de que quiere dar permisos de operador al usuario?',
          secondary: 'El usuario podrá gestionar las audiencias del sujeto obligado de esta dependencia.'
        },
        callback: {
          confirm: => 
            @submitNew(userData, dependencyData)
        }
      }
      new audiencias.views.ImportantMessage(messageOptions)

  submitNew: (userData, dependencyData) =>
    $.ajax(
      url: '/administracion/nuevo_operador'
      data: { user: userData, dependency: dependencyData }
      method: 'POST'
      success: (response) =>
        if response.dependency and response.dependency.obligee and response.dependency.obligee.users
          @users = response.dependency.obligee.users
          @render()
    )

  submitEdit: =>
    editedUsers = @$el.find('.user.edited')
    requests = []
    for editedUser in editedUsers
      newData = $(editedUser).data('user')
      requests.push($.ajax(
        url: '/administracion/actualizar_usuario'
        data: {user: newData }
        method: 'POST'
      ))
    requests

  submitRemove: =>
    removedUsers = @$el.find('.user.removed')
    requests = []
    for user in removedUsers
      userData = $(user).data('user')
      requests.push($.ajax(
        url: '/administracion/eliminar_operador'
        data: { user: { id: userData.id }, dependency: { id: @dependency.id } } 
        method: 'POST'
      ))
    requests