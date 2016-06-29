class audiencias.views.Result extends Backbone.View
  className: 'result-el'
  template: JST["backbone/templates/search/result"]

  initialize: (options) ->
    @audience = options.audience

  render: ->
    @$el.html(@template(
      audience: @audience 
    ))
