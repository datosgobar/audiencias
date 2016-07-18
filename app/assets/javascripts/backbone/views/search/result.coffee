class audiencias.views.Result extends Backbone.View
  className: 'result-el'
  template: JST["backbone/templates/search/result"]
  historicTemplate: JST["backbone/templates/search/result_historic"]
  events:
    'click': 'showFullResult'

  initialize: (options) ->
    @audience = options.audience
    @historicFlag = options.historic

  render: ->
    if @historicFlag
      @$el.html(@historicTemplate(
        audience: @audience
      ))
    else
      @$el.html(@template(
        audience: @audience 
      ))

  showFullResult: =>
    fullResult = new audiencias.views.FullResult(audience: @audience)
    if window.history and history.pushState
      fullResult.render()
      @$el.after(fullResult.el)
      $('body').addClass('showing-full-audience')
      title = $(document).find("title").text()
      history.replaceState({}, title, fullResult.audienceUrl)
    else
      window.location.href = fullResult.audienceUrl;

