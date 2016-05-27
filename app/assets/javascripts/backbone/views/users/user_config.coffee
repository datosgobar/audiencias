class audiencias.views.UserConfig extends Backbone.View
  template: JST["backbone/templates/users/user_config"]
  id: 'user-config'
  events:
    'click #save-user-config': 'attemptConfigEdit'

  initialize: ->
    audiencias.globals.users.on('change add', @render)

  render: =>
    @$el.html(@template(
      updated: @updated
    ))

  attemptConfigEdit: =>
    @updated = false
    @$el.find('.successfull-update').addClass('hidden')
    validations = @checkValidations()
    if validations.allValid
      data = validations.data
      $.ajax(
        url: '/intranet/configuracion',
        data: data
        method: 'POST'
        success: (response) =>
          if response.success and response.user
            @updated = true
            audiencias.globals.users.updateUser(response.user)
      )

  checkValidations: =>
    validation = {
      allValid: true,
      data: { user: {} }
    }

    newEmail = @$el.find('#new-email').val().trim()
    if newEmail.length > 0
      validation.data.user.email = newEmail
      validation.emailValid = /[\w+\-.]+@[a-z\d\-.]+\.[a-z]+/i.test(newEmail)
      validation.allValid = validation.allValid and validation.emailValid
      @$el.find('#new-email').toggleClass('invalid', !validation.emailValid)

    newPassword = @$el.find('#new-password').val().trim()
    newPasswordConfirmation = @$el.find('#confirm-new-password').val()
    if newPassword.length > 0
      validation.data.user.password = newPassword
      validation.passwordValid = newPassword.length > 5 and newPassword == newPasswordConfirmation
      validation.allValid = validation.allValid and validation.passwordValid
      @$el.find('#new-password, #confirm-new-password').toggleClass('invalid', !validation.passwordvalid)

    unless newEmail.length > 0 or newPassword.length > 0
      validation.allValid = false
    validation