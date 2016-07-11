class audiencias.views.FullResult extends Backbone.View
  className: 'full-result'
  template: JST["backbone/templates/search/full_result"]
  events: 
    'click .background-veil': 'remove'

  initialize: (options) ->
    @audience = options.audience

  render: ->
    @$el.html(@template(
      audience: @audience 
    ))
