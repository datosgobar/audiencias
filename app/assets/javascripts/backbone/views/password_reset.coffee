class audiencias.views.PasswordReset extends Backbone.View
  template: JST["backbone/templates/password_reset/password_reset"]
  sendResetLink: JST["backbone/templates/password_reset/send_reset_link"]
  changePassword: JST["backbone/templates/password_reset/change_password"]
  id: 'password-reset'

  events: 
    'click #submit-email': 'validateEmailRequest'
    'click #submit-password.enabled': 'sendNewPassword'
    'input #password': 'updateSubmitButton'
    'input #password-confirm': 'updateSubmitButton'
    'keyup #id': 'sendEmailIfEnter'
    'keyup #password': 'submitNewPasswordIfEnter'
    'keyup #password-confirm': 'submitNewPasswordIfEnter'

  renderSendResetLink: ->
    @$el.html(@template())
    @$el.find('#password-reset-card').html(@sendResetLink())

  renderUpdatePasswordForm: (formOptions) ->
    @$el.html(@template())
    form = @changePassword(formOptions)
    @$el.find('#password-reset-card').html(form)

  validateEmailRequest: =>
    idInput = $('#password-reset #id')
    hasId = idInput.val().trim().length > 0
    idInput.toggleClass('invalid', !hasId)

    if hasId
      @sendResetEmail()
   
  sendResetEmail: ->
    data = {
      id: $('#password-reset #id').val(),
      id_type: $('#password-reset #id-type').val()
    }
    $.ajax({
      type: 'POST',
      url: '/resetear_credenciales', 
      data: data,
      success: @showEmailSentMessage
    })

  showEmailSentMessage: =>
    messageOptions = {
      icon: 'pass',
      confirmation: false,
      text: {
        main: 'Se envió la recuperación de contraseña a la dirección de correo electronico del usuario.',
        secondary: 'En caso de no recibir el correo o no poder acceder a la casilla, comunicarse con el respectivo administrador de sistema.'
      },
      callback: {
        confirm: => 
          window.location.href = "/ingresar"
      }
    }
    message = new audiencias.views.ImportantMessage(messageOptions)

  updateSubmitButton: ->
    passwordInput = $('#password-reset #password')
    passwordValue = passwordInput.val()

    passwordConfirmInput = $('#password-reset #password-confirm')
    passwordConfirmValue = passwordConfirmInput.val()

    if passwordValue.length >= 6 and passwordConfirmValue.length >= 6 and passwordValue == passwordConfirmValue
      $('#submit-password').removeClass('disabled').addClass('enabled')
    else
      $('#submit-password').addClass('disabled').removeClass('enabled')

  sendNewPassword: ->
    data = {
      password: $('#password-reset #password').val()
    }
    $.ajax({
      type: 'POST',
      data: data,
      success: (response) =>
        if response.success
          @showPasswordChangedMessage()
    })

  showPasswordChangedMessage: =>
    messageOptions = {
      icon: 'pass',
      confirmation: false,
      text: {
        main: 'Se ha actualizado la contraseña del usuario.',
        secondary: 'Ya puede ingresar usando su nueva contraseña.'
      },
      callback: {
        confirm: => 
          window.location.href = "/ingresar"
      }
    }
    message = new audiencias.views.ImportantMessage(messageOptions)

  sendEmailIfEnter: (e) =>
    @validateEmailRequest() if e.keyCode == 13

  submitNewPasswordIfEnter: (e) =>
    if e.keyCode == 13 and $('#submit-password').hasClass('enabled')
      @sendNewPassword()