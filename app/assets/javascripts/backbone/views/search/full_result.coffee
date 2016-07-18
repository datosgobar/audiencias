class audiencias.views.FullResult extends Backbone.View
  className: 'single-audience full-result'
  template: JST["backbone/templates/search/full_result"]
  events: 
    'click .background-veil': 'die'

  initialize: (options) ->
    @audience = options.audience
    @audienceUrl = "/audiencia?id=#{@audience.id}"
    @currentLocation = window.location.href

  render: ->
    @$el.html(@template(
      audience: @audience 
    ))

  die: =>
    title = $(document).find("title").text()
    if @currentLocation != window.location.href
      history.replaceState({}, title, @currentLocation)
    else
      history.replaceState({}, title, '/')
    $('body').removeClass('showing-full-audience')
    @remove()