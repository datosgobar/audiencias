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

  addUserFromForm: =>
    validation = @validateUser('.new-user-form')
    if validation.valid
      data = validation.data
      data.associations = [{ type: 'obligee', id: @dependency.obligee.id }]
      @submitNew(data)

  submitNew: (data) =>
    $.ajax(
      url: '/administracion/nuevo_usuario'
      data: JSON.stringify(data)
      method: 'POST'
      dataType: 'json'
      contentType: 'application/json'
      success: (response) =>
        if response and response.success
          @trigger('reload-dependency')
    )