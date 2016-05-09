class audiencias.views.ImportantMessage extends Backbone.View
  template: JST["backbone/templates/important_message"]
  id: 'important-message'
  className: 'global-veil'
  events:
    'click #important-message-cancel': 'cancelCallback'
    'click #important-message-confirm': 'confirmCallback'

  initialize: (@options)->
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