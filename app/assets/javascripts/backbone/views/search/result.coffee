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
    fullResult.render()
    @$el.after(fullResult.el)
