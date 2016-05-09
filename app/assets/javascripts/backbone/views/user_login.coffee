class audiencias.views.UserLogin extends Backbone.View
  template: JST["backbone/templates/user_login"]
  id: 'login'
  events: 
    'keyup #id': 'submitIfEnter'
    'keyup #password': 'submitIfEnter'
    'click #submit': 'validateInputs'
    'change #remember-me': 'toggleCheckImg'

  render: ->
    @$el.html(@template())

  submitIfEnter: (e) =>
    @validateInputs() if e.keyCode == 13

  validateInputs: =>
    idInput = $('#id')
    hasId = idInput.val().trim().length > 0
    idInput.toggleClass('invalid', !hasId)

    passwordInput = $('#password')
    hasPassword = passwordInput.val().length > 0
    passwordInput.toggleClass('invalid', !hasPassword)

    if hasId and hasPassword
      @doLogin()
   
  doLogin: =>
    data = {
      id: $('#id').val().trim(),
      id_type: $('#id-type').val(),
      password: $('#password').val(),
      remember_me: $('#remember-me').is(':checked')
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

  toggleCheckImg: ->
    checked = $('#remember-me').is(':checked')
    $('#checked').toggleClass('hidden', !checked)
    $('#unchecked').toggleClass('hidden', checked)