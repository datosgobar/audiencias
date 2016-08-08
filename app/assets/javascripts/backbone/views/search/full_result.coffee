class audiencias.views.FullResult extends Backbone.View
  className: 'single-audience full-result'
  template: JST["backbone/templates/search/full_result"]
  historicTemplate: JST["backbone/templates/search/full_result_historic"]
  events: 
    'click .background-veil': 'die'
    'click .close': 'die'

  initialize: (options) ->
    @audience = options.audience
    @historicFlag = options.historic
    if @historicFlag
      @audienceUrl = "/audiencia_historica?id=#{@audience.id_audiencia}"
    else
      @audienceUrl = "/audiencia?id=#{@audience.id}"
    @currentLocation = window.location.href

  render: ->
    if @historicFlag
      @$el.html(@historicTemplate(
        audience: @audience
      ))
    else
      @$el.html(@template(
        audience: @audience 
      ))
    $(document).on('keydown', @dieIfEsc)

  die: =>
    title = $(document).find("title").text()
    if @currentLocation != window.location.href
      history.replaceState({}, title, @currentLocation)
    else
      history.replaceState({}, title, '/')
    $('body').removeClass('showing-full-audience')
    @remove()

  dieIfEsc: (e) =>
    if e.keyCode == 27
      $(document).off('keydown', @dieIfEsc)
      @die()
