class audiencias.views.UnexpectedErrorHandler extends Backbone.View
  id: 'error-bar'
  className: 'hidden'
  template: JST["backbone/templates/errors/unexpected_error"]
  events:
    'click .hide-error-bar': 'hide'

  initialize: ->
    @$el.html(@template())
    $('body').append(@el)
    $(document).ajaxError(@errorHandler)

  errorHandler: =>
    $('body').addClass('showing-error-bar')
    @$el.removeClass('hidden')

  hide: =>
    $('body').removeClass('showing-error-bar')
    @$el.addClass('hidden')