#= require ./user_list
class audiencias.views.OperatorList extends audiencias.views.UserList
  title: 'Operadores'

  initialize: (dependency) ->
    @dependency = dependency
    @obligee = dependency.obligee
    if @obligee and @obligee.users
      @users = @obligee.users
    else 
      @users = []

  render: ->
    if @obligee
      super()
      @renderUsers()
      @setAutocomplete()

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