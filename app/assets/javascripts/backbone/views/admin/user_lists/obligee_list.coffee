#= require ./user_list
class audiencias.views.ObligeeList extends audiencias.views.UserList
  title: 'Sujeto obligado'
  positionInForm: true

  initialize: (dependency) ->
    super()
    @dependency = dependency
    @setUsers()

  setUsers: =>
    if @dependency.obligee and @dependency.obligee.person
      @dependency.obligee.person.role = 'obligee'
      @users = [@dependency.obligee.person]
      @users[0].position = @dependency.obligee.position
    else
      @users = []

  render: ->
    super()
    @hideAddUserImg() if @users.length > 0

  validateUser: (formSelector) =>
    validation = super(formSelector)

    positionInput = @$el.find(formSelector).find('.position-input')
    validation.data.position = positionInput.val().trim()
    
    positionValid = @validateName(validation.data.position)
    positionInput.toggleClass('invalid', !positionValid)
    
    validation.valid = validation.valid && positionValid
    validation

  addUserFromForm: =>
    validation = @validateUser('.new-user-form')
    if validation.valid
      data = {
        person: {
          person_id: validation.data.person_id
          id_type: validation.data.id_type
          name: validation.data.name
          surname: validation.data.surname
          email: validation.data.email
        }
        dependency: {
          id: @dependency.id
        }
        obligee: {
          position: validation.data.position
        }
      }
      messageOptions = {
        icon: 'alert',
        confirmation: true,
        text: {
          main: '¿Está seguro de que quiere agregar un nuevo sujeto obligado?',
          secondary: 'El cambio quedara guardado en la base de datos y será visible al público.'
        },
        callback: {
          confirm: => 
            @submitNew(data)
        }
      }
      new audiencias.views.ImportantMessage(messageOptions)

  submitNew: (data) =>
    $.ajax(
      url: '/administracion/nuevo_sujeto_obligado'
      data: data
      method: 'POST'
      success: (response) =>
        if response and response.dependency
          @dependency = response.dependency
          oldDependency = _.find(audiencias.globals.dependencies.plain, (d) => d.id == @dependency.id)
          audiencias.globals.dependencies.plain[oldDependency.index] = @dependency
          @setUsers()
          @render()
    )

  submitEdit: =>
    editedUsers = @$el.find('.user.edited')
    requests = []
    for editedUser in editedUsers
      newData = $(editedUser).data('user')
      newPersonData = {
        name: newData.name,
        surname: newData.surname,
        email: newData.email
      }
      newObligeeData = {
        id: @dependency.obligee.id,
        position: newData.position
      }
      requests.push($.ajax(
        url: '/administracion/actualizar_sujeto_obligado'
        data: { obligee: newObligeeData, person: newPersonData, dependency: { id: @dependency.id } }
        method: 'POST'
      ))
    requests

  submitRemove: =>
    removedUsers = @$el.find('.user.removed')
    requests = []
    for user in removedUsers
      requests.push($.ajax(
        url: '/administracion/eliminar_sujeto_obligado'
        data: { dependency: { id: @dependency.id } } 
        method: 'POST'
      ))
    requests