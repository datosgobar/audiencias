#= require ./user_list
class audiencias.views.SupervisorList extends audiencias.views.UserList
  title: 'Supervisores'

  initialize: ->
    super()
    $(window).on('globals:users:loaded', @filterUsers)

  filterUsers: =>
    @users = _.filter(audiencias.globals.users, (u) -> u.role == 'superadmin')
    @renderUsers()

  defaultView: =>
    @renderUsers()
    @showUserList()
    @showAddUserImg()

  addUserFromForm: =>
    validation = @validateUser('.new-user-form')
    if validation.valid
      @submitNew(validation.data)

  saveEditUser: =>
    validation = @validateUser('.edit-user-form')
    if validation.valid
      @replaceUserElement(validation.data)

  replaceUserElement: (user) =>
    for userEl in @$el.find('.user')
      data = $(userEl).data('user')
      if data.id_type == user.id_type and data.person_id.toString() == user.person_id
        data.name = user.name
        data.surname = user.surname
        data.email = user.email
        newUserEl = $(@userTemplate(data))
        newUserEl.data('user', data)
        newUserEl.addClass('editable edited')
        $(userEl).replaceWith(newUserEl)
    @showUserList()

  submitNew: (userData) =>
    $.ajax(
      url: '/administracion/nuevo_supervisor'
      data: { user: userData }
      method: 'POST'
      success: =>
        audiencias.globals.loadUsers()
        @defaultView()
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

  submitChanges: =>
    if @$el.find('.user.removed').length > 0
      @submitRemove()
    else if @$el.find('.user.edited').length > 0
      @submitEdit()
    else
      @defaultView()
