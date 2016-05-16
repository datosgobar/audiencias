#= require ./user_list
class audiencias.views.AdminList extends audiencias.views.UserList
  className: 'user-list hidden'
  title: 'Administradores'

  initialize: (dependency) ->
    super()
    @dependency = dependency
    @users = dependency.users || []

  showAdminList: =>
    @$el.removeClass('hidden')

  hideAdminList: =>
    @$el.addClass('hidden')

  addUserFromForm: =>
    validation = @validateUser('.new-user-form')
    if validation.valid
      userData = validation.data
      dependencyData = { id: @dependency.id }
      messageOptions = {
        icon: 'alert',
        confirmation: true,
        text: {
          main: '¿Está seguro de que quiere dar permisos de administrador al usuario?',
          secondary: 'El usuario podrá administrar sujetos obligados, usuarios y otras dependencias que dependendan de la actual.'
        },
        callback: {
          confirm: => 
            @submitNew(userData, dependencyData)
        }
      }
      new audiencias.views.ImportantMessage(messageOptions)

  submitNew: (userData, dependencyData) =>
    $.ajax(
      url: '/administracion/nuevo_administrador'
      data: { user: userData, dependency: dependencyData }
      method: 'POST'
      success: (response) =>
        if response.dependency and response.dependency.users
          @users = response.dependency.users
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
        url: '/administracion/eliminar_administrador'
        data: { user: { id: userData.id }, dependency: { id: @dependency.id}  } 
        method: 'POST'
      ))
    requests