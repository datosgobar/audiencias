class Audiencias.Views.PasswordReset extends Backbone.View
  template: JST["backbone/templates/password_reset"]
  sendResetLink: JST["backbone/templates/send_reset_link"]
  changePassword: JST["backbone/templates/change_password"]

  id: 'password-reset'

  events: 
    'click #submit-email': 'sendResetEmail'

  render: (subTemplate='sendResetLink') ->
    @$el.html(@template())
    @$el.find('#password-reset-card').html(@[subTemplate]())
   
  sendResetEmail: ->
    data = {
      id: $('#login #id').val(),
      id_type: $('#login #id-type').val()
    }
    $.ajax({
      type: 'POST',
      url: '/ingresar', 
      data: data, 
      success: @loginCallback,
      error: @loginError
    })