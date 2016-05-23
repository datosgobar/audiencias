class audiencias.views.OperatorNavigation extends Backbone.View
  id: 'operator-navigation'
  template: JST["backbone/templates/operator/operator_navigation"]
  events:
    'change .search-type-radio': 'searchTypeChange'

  initialize: ->
    @searchType = 'text'
    audiencias.globals.obligees.on('add change remove', @render)

  render: =>
    @$el.html(@template(
      searchType: @searchType
    ))

  searchTypeChange: (e) =>
    @searchType = @$el.find('.search-type-radio:checked').val()
    @render()