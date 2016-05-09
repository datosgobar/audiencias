#= require ./user_list
class audiencias.views.SupervisorList extends audiencias.views.UserList

  initialize: ->
    @title = 'Supervisores'

  renderSupervisors: =>
    for supervisor in audiencias.globals.supervisors
      user = @userTemplate(supervisor)
      @$el.find('.users').append(user)

  loadSupervisors: =>
    $.ajax(
      url: '/administracion/listar_supervisores'
      method: 'GET'
      success: (response) =>
        audiencias.globals.supervisors = response
        @renderSupervisors()
    )