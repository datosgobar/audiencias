class audiencias.views.OperatorLanding extends Backbone.View
  id: 'operator-landing'
  template: JST["backbone/templates/operator/operator_landing"]

  initialize: ->
    @navigationView = new audiencias.views.OperatorNavigation
    @audiencesView = new audiencias.views.OperatorAudiences

  render: ->
    @$el.html(@template())
    @navigationView.render()
    @audiencesView.render()
    @$el.find('#operator-navigation-container').html(@navigationView.el)
    @$el.find('#operator-audiences-container').html(@audiencesView.el)