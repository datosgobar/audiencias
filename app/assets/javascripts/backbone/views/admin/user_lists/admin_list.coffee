#= require ./user_list
class audiencias.views.AdminList extends audiencias.views.UserList
  className: 'user-list hidden'
  title: 'Administradores'

  initialize: (dependency) ->
    super()
    @dependency = dependency
    @users = dependency.users || []

  render: ->
    super()
    @renderUsers()
    @setAutocomplete()

  showAdminList: =>
    @$el.removeClass('hidden')

  hideAdminList: =>
    @$el.addClass('hidden')

  addUserFromForm: =>
    validation = @validateUser('.new-user-form')
    if validation.valid
      userData = validation.data
      dependencyData = { id: @dependency.id }
      @submitNew(userData, dependencyData)

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