#= require ./user_list
class audiencias.views.SupervisorList extends audiencias.views.UserList
  title: 'Supervisores'

  initialize: ->
    audiencias.globals.users.on('add remove change', @render)
    super()
    $(window).on('globals:users:loaded', =>
      @filterUsers()
    )

  filterUsers: =>
    @users = audiencias.globals.users.filter((u) -> u.role == 'superadmin')
    console.log(@users)
    @render()

  addUserFromForm: =>
    validation = @validateUser('.new-user-form')
    if validation.valid
      messageOptions = {
        icon: 'alert',
        confirmation: true,
        text: {
          main: '¿Está seguro de que quiere dar permisos de supervisor al usuario?',
          secondary: 'El usuario podrá administrar dependencias, sujetos obligados y demás usuarios'
        },
        callback: {
          confirm: => 
            @submitNew(validation.data)
        }
      }
      new audiencias.views.ImportantMessage(messageOptions)

  submitNew: (userData) =>
    $.ajax(
      url: '/administracion/nuevo_supervisor'
      data: { user: userData }
      method: 'POST'
      success: audiencias.globals.loadUsers
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
    $.when.apply($, requests).done(audiencias.globals.loadUsers)

  submitRemove: =>
    removedUsers = @$el.find('.user.removed')
    requests = []
    for user in removedUsers
      userData = $(user).data('user')
      requests.push($.ajax(
        url: '/administracion/eliminar_supervisor'
        data: { user: userData } 
        method: 'POST'
      ))
    $.when.apply($, requests).done(audiencias.globals.loadUsers)