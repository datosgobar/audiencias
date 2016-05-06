class Audiencias.Views.PasswordReset extends Backbone.View
  template: JST["backbone/templates/password_reset"]
  sendResetLink: JST["backbone/templates/send_reset_link"]
  changePassword: JST["backbone/templates/change_password"]

  id: 'password-reset'

  events: 
    'click #submit-email': 'validateEmailRequest'
    'click #submit-password.enabled': 'sendNewPassword'
    'input #password': 'updateSubmitButton'
    'input #password-confirm': 'updateSubmitButton'

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
      data: data
    })

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
      data: data
    })