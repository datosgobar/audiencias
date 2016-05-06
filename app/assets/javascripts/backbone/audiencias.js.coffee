#= require_self
#= require_tree ./templates
#= require_tree ./views

window.Audiencias =
  Views: {}
  App: {
    RenderHeader: ->
      header = new Audiencias.Views.Header
      header.render()
      $('body').prepend(header.el)

    UserLogin: ->
      @RenderHeader()
      userLogin = new Audiencias.Views.UserLogin
      userLogin.render()
      $('body').append(userLogin.el)

    SendPasswordReset: ->
      @RenderHeader()
      passwordReset = new Audiencias.Views.PasswordReset
      passwordReset.renderSendResetLink()
      $('body').append(passwordReset.el)

    UpdatePassword: (formOptions) ->
      @RenderHeader()
      passwordReset = new Audiencias.Views.PasswordReset
      passwordReset.renderUpdatePasswordForm(formOptions)
      $('body').append(passwordReset.el)
  }
