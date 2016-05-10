#= require ./user_list
class audiencias.views.SupervisorList extends audiencias.views.UserList

  initialize: ->
    @title = 'Supervisores'

  loadSupervisors: =>
    $.ajax(
      url: '/administracion/listar_supervisores'
      method: 'GET'
      success: (response) =>
        audiencias.globals.supervisors = response
        @renderUsers(audiencias.globals.supervisors)
    )

  defaultView: =>
    @loadSupervisors()
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

  validateUser: (formSelector) =>
    $form = @$el.find(formSelector)
    data = {
      id_type: $form.find('.id-type-select').val().trim(),
      person_id: $form.find('.person-id-input').val(),
      name: $form.find('.name-input').val().trim(),
      surname: $form.find('.surname-input').val().trim(),
      email: $form.find('.email-input').val().trim(),
    }
    
    idValid = @validatePersonId(data.person_id)
    $form.find('.id-input').toggleClass('invalid', !idValid)
    nameValid = @validateName(data.name)
    $form.find('.name-input').toggleClass('invalid', !nameValid)
    surnameValid = @validateName(data.surname)
    $form.find('.surname-input').toggleClass('invalid', !surnameValid)
    emailValid = @validateEmail(data.email)
    $form.find('.email-input').toggleClass('invalid', !emailValid)
    
    {
      valid: idValid and nameValid and surnameValid and emailValid,
      data: data 
    }

  submitNew: (data) =>
    $.ajax(
      url: '/administracion/nuevo_supervisor'
      data: data
      method: 'POST'
      success: (response) =>
        if response and response.success
          @defaultView()
    )

  submitEdit: =>
    editedUsers = @$el.find('.user.edited')
    data = { users: [] }
    for editedUser in editedUsers
      newData = $(editedUser).data('user')
      data.users.push(newData)
    $.ajax(
      url: '/administracion/actualizar_supervisores'
      data: data 
      method: 'POST'
      success: (response) =>
        if response and response.success
          @defaultView()
    )

  submitRemove: =>
    removedUsers = @$el.find('.user.removed')
    data = { users: [] }
    for user in removedUsers
      userData = $(user).data('user')
      data.users.push({ person_id: userData.person_id, id_type: userData.id_type })
    $.ajax(
      url: '/administracion/eliminar_supervisores'
      data: data 
      method: 'POST'
      success: (response) =>
        if response and response.success
          @defaultView()
    )

  submitChanges: =>
    if @$el.find('.user.removed').length > 0
      @submitRemove()
    else if @$el.find('.user.edited').length > 0
      @submitEdit()
    else
      @defaultView()
