#= require ./user_list
class audiencias.views.ObligeeList extends audiencias.views.UserList
  title: 'Sujeto obligado'
  positionInForm: true

  initialize: (dependency) ->
    @dependency = dependency
    @setUsers()
    if @dependency.obligee and @dependency.obligee.person
      @users = [@dependency.obligee.person]
    else
      @users = []

  setUsers: =>
    if @dependency.obligee and @dependency.obligee.person
      @dependency.obligee.person.role = 'obligee'
      @users = [@dependency.obligee.person]
    else
      @users = []

  render: ->
    super()
    @renderUsers()
    @hideAddUserImg() if @users.length > 0

  validateUser: (formSelector) =>
    positionInput = @$el.find(formSelector).find('.position-input')
    validation = super(formSelector)
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
      @submitNew(data)

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