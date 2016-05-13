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
      @submitNew(userData, dependencyData)

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
        data: { user: { id: userData.id }, obligee: { id: @obligee.id } } 
        method: 'POST'
      ))
    requests