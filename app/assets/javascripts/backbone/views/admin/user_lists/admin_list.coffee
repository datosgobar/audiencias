#= require ./user_list
class audiencias.views.AdminList extends audiencias.views.UserList
  className: 'user-list hidden'
  title: 'Administradores'

  render: (dependency) =>
    super()
    @dependency = dependency
    @renderUsers(dependency.users)

  toggleShow: =>
    @$el.toggleClass('hidden')

  addUserFromForm: =>
    validation = @validateUser('.new-user-form')
    if validation.valid
      data = validation.data
      data.associations = [{ type: 'dependency', id: @dependency.id }]
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