class Audiencias.Views.UserLogin extends Backbone.View
  template: JST["backbone/templates/user_login"]
  id: 'login'
  events: 
    'click #submit': 'validateInputs'

  render: ->
    @$el.html(@template())

  validateInputs: =>
    idInput = $('#login #id')
    hasId = idInput.val().trim().length > 0
    idInput.toggleClass('invalid', !hasId)

    passwordInput = $('#login #password')
    hasPassword = passwordInput.val().length > 0
    passwordInput.toggleClass('invalid', !hasPassword)

    if hasId and hasPassword
      @doLogin()
   
  doLogin: =>
    data = {
      id: $('#login #id').val().trim(),
      id_type: $('#login #id-type').val(),
      password: $('#login #password').val(),
      remember_me: $('#login #remember-me').is(':checked')
    }
    $.ajax({
      type: 'POST',
      url: '/ingresar', 
      data: data, 
      success: @loginCallback,
      error: @loginError
    })

  loginCallback: (response) =>
    if response and response.success 
      window.location.replace('/')
    else if response and response.message 
      @$el.find('#message').text(response.message)
    else
      @loginError()

  loginError: =>
    errorMessage = 'Ha ocurrido un error. Por favor espere unos minutos y vuelva a intentar.'
    @$el.find('#message').text(errorMessage)