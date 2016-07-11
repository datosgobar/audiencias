class audiencias.views.Result extends Backbone.View
  className: 'result-el'
  template: JST["backbone/templates/search/result"]
  events:
    'click': 'showFullResult'

  initialize: (options) ->
    @audience = options.audience

  render: ->
    @$el.html(@template(
      audience: @audience 
    ))

  showFullResult: =>
    fullResult = new audiencias.views.FullResult(audience: @audience)
    if window.history and history.pushState
      fullResult.render()
      @$el.after(fullResult.el)
      title = $(document).find("title").text()
      history.replaceState({}, title, fullResult.audienceUrl)
    else
      window.location.href = fullResult.audienceUrl;

