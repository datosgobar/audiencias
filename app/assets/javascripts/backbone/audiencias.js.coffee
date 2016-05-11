#= require_self
#= require_tree ./templates
#= require_tree ./views

window.audiencias =
  views: {}
  app: {
    renderHeader: ->
      header = new audiencias.views.Header
      header.render()
      $('body').prepend(header.el)

    userLogin: ->
      @renderHeader()
      userLogin = new audiencias.views.UserLogin
      userLogin.render()
      $('body').append(userLogin.el)

    sendPasswordReset: ->
      @renderHeader()
      passwordReset = new audiencias.views.PasswordReset
      passwordReset.renderSendResetLink()
      $('body').append(passwordReset.el)

    updatePassword: (formOptions) ->
      @renderHeader()
      passwordReset = new audiencias.views.PasswordReset
      passwordReset.renderUpdatePasswordForm(formOptions)
      $('body').append(passwordReset.el)

    adminLanding: ->
      audiencias.globals.loadDependencies()
      audiencias.globals.loadUsers()

      @renderHeader()
      adminLanding = new audiencias.views.AdminLanding 
      adminLanding.render()
      $('body').append(adminLanding.el)

    operatorLanding: ->
      @renderHeader()
      operatorLanding = new audiencias.views.OperatorLanding 
      operatorLanding.render()
      $('body').append(operatorLanding.el)
  }
  globals: {
    loadDependencies: ->
      $.ajax(
        url: '/administracion/listar_dependencias'
        method: 'POST'
        success: (response) =>
          audiencias.globals.dependencies = response.dependencies
          $(window).trigger('globals:dependencies:loaded')
      )
    loadUsers: ->
      $.ajax(
        url: '/administracion/listar_usuarios'
        method: 'POST'
        success: (response) =>
          audiencias.globals.users = response.users
          $(window).trigger('globals:users:loaded')
      )
  }
