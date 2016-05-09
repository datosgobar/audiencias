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
    data = {
      id_type: @$el.find('.new-user-form .id-type-select').val().trim(),
      id: @$el.find('.new-user-form .id-input').val(),
      name: @$el.find('.new-user-form .name-input').val().trim(),
      surname: @$el.find('.new-user-form .surname-input').val().trim(),
      email: @$el.find('.new-user-form .email-input').val().trim(),
    }
    
    idValid = @validateId(data.id)
    @$el.find('.new-user-form .id-input').toggleClass('invalid', !idValid)
    nameValid = @validateName(data.name)
    @$el.find('.new-user-form .name-input').toggleClass('invalid', !nameValid)
    surnameValid = @validateName(data.surname)
    @$el.find('.new-user-form .surname-input').toggleClass('invalid', !surnameValid)
    emailValid = @validateEmail(data.email)
    @$el.find('.new-user-form .email-input').toggleClass('invalid', !emailValid)

    if idValid and nameValid and surnameValid and emailValid
      @submitNew(data)

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

  submitRemove: =>

  submitChanges: =>
    removedUsers = @$el.find('.user.removed')
    data = { users: [] }
    for user in removedUsers
      userData = $(user).data('user')
      data.users.push({ id: userData.dni, id_type: userData.id_type })
    $.ajax(
      url: '/administracion/eliminar_supervisores'
      data: data 
      method: 'POST'
      success: (response) =>
        if response and response.success
          @defaultView()
    )