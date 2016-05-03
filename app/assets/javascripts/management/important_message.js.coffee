class window.ImportantMessage

  constructor: ->
    @listenEvents()

  listenEvents: ->
    $(window).on('important-message', @showMessage)
    $('#important-message .cancel').on('click', @cancel)
    $('#important-message .confirm').on('click', @confirm)

  showMessage: (e, options) =>
    @showIcon(options.icon)
    @showText(options.text.main, options.text.secondary)
    @showButtons(options.confirmation)
    @callback = options.callback
    $('#important-message').removeClass('hidden')

  showIcon: (icon) =>
    $("#important-message .image-container #{icon}").removeClass('hidden')
      .siblings().addClass('hidden')

  showText: (main, secondary) =>
    if main
      $('#important-message .text .main').text(main).removeClass('hidden')
    else
      $('#important-message .text .main').addClass('hidden')

    if secondary
      $('#important-message .text .secondary').text(secondary).removeClass('hidden')
    else
      $('#important-message .text .secondary').addClass('hidden')

  showButtons: (confirmationNeeded) =>
    if confirmationNeeded
      $('#important-message .buttons').addClass('confirm')
    else 
      $('#important-message .buttons').removeClass('confirm')

  cancel: =>
    $('#important-message').addClass('hidden')
    if @callback.cancel 
      @callback.cancel()

  confirm: =>
    $('#important-message').addClass('hidden')
    if @callback.confirm 
      @callback.confirm()