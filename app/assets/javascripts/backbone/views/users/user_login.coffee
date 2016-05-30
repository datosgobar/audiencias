class audiencias.views.UserLogin extends Backbone.View
  template: JST["backbone/templates/users/user_login"]
  id: 'login'
  events: 
    'keyup #person-id': 'submitIfEnter'
    'keyup #password': 'submitIfEnter'
    'click #submit': 'validateInputs'
    'change #remember-me': 'toggleCheckImg'

  render: ->
    @$el.html(@template())

  submitIfEnter: (e) =>
    @validateInputs() if e.keyCode == 13

  validateInputs: =>
    idInput = @$el.find('#person-id')
    hasId = idInput.val().trim().length > 0
    idInput.toggleClass('invalid', !hasId)

    passwordInput = @$el.find('#password')
    hasPassword = passwordInput.val().length > 0
    passwordInput.toggleClass('invalid', !hasPassword)

    if hasId and hasPassword
      @doLogin()
   
  doLogin: =>
    data = {
      person_id: @$el.find('#person-id').val().trim(),
      id_type: @$el.find('#id-type').val(),
      password: @$el.find('#password').val(),
      remember_me: @$el.find('#remember-me').is(':checked')
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
      NProgress.start()
      window.location.replace('/')
    else if response and response.message 
      @$el.find('#message').text(response.message)
    else
      @loginError()

  loginError: =>
    errorMessage = 'Ha ocurrido un error. Por favor espere unos minutos y vuelva a intentar.'
    @$el.find('#message').text(errorMessage)

  toggleCheckImg: =>
    checked = @$el.find('#remember-me').is(':checked')
    @$el.find('#checked').toggleClass('hidden', !checked)
    @$el.find('#unchecked').toggleClass('hidden', checked)