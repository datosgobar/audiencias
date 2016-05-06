class Audiencias.Views.PasswordReset extends Backbone.View
  template: JST["backbone/templates/password_reset"]
  sendResetLink: JST["backbone/templates/send_reset_link"]
  changePassword: JST["backbone/templates/change_password"]

  id: 'password-reset'

  events: 
    'click #submit-email': 'sendResetEmail'
    'click #submit-password': 'sendNewPassword'

  renderSendResetLink: ->
    @$el.html(@template())
    @$el.find('#password-reset-card').html(@sendResetLink())

  renderUpdatePasswordForm: (formOptions) ->
    @$el.html(@template())
    form = @changePassword(formOptions)
    @$el.find('#password-reset-card').html(form)
   
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

  sendNewPassword: ->
    data = {
      password: $('#password-reset #password').val()
    }
    $.ajax({
      type: 'POST',
      data: data
    })