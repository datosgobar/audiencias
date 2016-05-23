class audiencias.views.OperatorNavigation extends Backbone.View
  id: 'operator-navigation'
  template: JST["backbone/templates/operator/operator_navigation"]
  events:
    'change #current-obligee-select': 'changeCurrentObligee'

  initialize: ->
    audiencias.globals.obligees.on('add change remove', @render)

  render: =>
    @$el.html(@template())

  changeCurrentObligee: ->
    obligeeId = @$el.find('#current-obligee-select option:selected').val()
    window.location.href = "/intranet/audiencias/#{obligeeId}"
