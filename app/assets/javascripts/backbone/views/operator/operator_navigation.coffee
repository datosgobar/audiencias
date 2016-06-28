class audiencias.views.OperatorNavigation extends Backbone.View
  id: 'operator-navigation'
  template: JST["backbone/templates/operator/operator_navigation"]
  events:
    'change #current-obligee-select': 'changeCurrentObligee'
    'keyup #search': 'searchOnEnter'
    'click #search-icon': 'searchIfQuery'
    'click #clean-search': 'cleanSearch'

  initialize: ->
    audiencias.globals.obligees.on('add change remove', @render)

  render: =>
    @$el.html(@template())

  changeCurrentObligee: ->
    obligeeId = @$el.find('#current-obligee-select option:selected').val()
    NProgress.start()
    window.location.href = "/intranet/audiencias?sujeto_obligado=#{obligeeId}"

  searchOnEnter: (e) =>
    if e.keyCode == 13
      @searchIfQuery()

  searchIfQuery: =>
    query = @$el.find('#search').val().trim()
    if query.length > 0
      currentObligee = audiencias.globals.currentObligee
      window.location.href = "/intranet/audiencias?sujeto_obligado=#{currentObligee}&q=#{query}"

  cleanSearch: =>
    currentObligee = audiencias.globals.currentObligee
    window.location.href = "/intranet/audiencias?sujeto_obligado=#{currentObligee}"    