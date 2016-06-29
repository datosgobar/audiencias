class audiencias.views.ResultsList extends Backbone.View
  id: 'results'
  template: JST["backbone/templates/search/results_list"]

  render: ->
    @$el.html(@template())

    for audience in audiencias.globals.results.audiences
      resultElement = new audiencias.views.Result(audience: audience)
      resultElement.render()
      @$el.find('.results-list').append(resultElement.el)