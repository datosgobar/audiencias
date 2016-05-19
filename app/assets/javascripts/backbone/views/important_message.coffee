class audiencias.views.ImportantMessage extends Backbone.View
  template: JST["backbone/templates/important_message"]
  id: 'important-message'
  className: 'global-veil'
  events:
    'click #important-message-cancel': 'cancelCallback'
    'click #important-message-confirm': 'confirmCallback'

  initialize: (@options)->
    unless @options.text
      @options.text = { 
        main: '¿Está seguro del cambio que va a realizar?' 
        secondary: 'Recuerde que estos cambios afectan a la base de datos del sistema y se muestran públicamente.'
      }
    @render()
    $('body').append(@el)

  render: ->
    @$el.html(@template(@options))

  cancelCallback: =>
    @$el.addClass('hidden')
    if @options.callback and @options.callback.cancel
      @options.callback.cancel()

  confirmCallback: =>
    @$el.addClass('hidden')
    if @options.callback and @options.callback.confirm
      @options.callback.confirm()