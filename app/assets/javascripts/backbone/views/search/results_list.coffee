class audiencias.views.ResultsList extends Backbone.View
  id: 'results'
  template: JST["backbone/templates/search/results_list"]

  render: ->
    @$el.html(@template(
      linkCreator: @linkCreator
    ))

    for audience in audiencias.globals.results.audiences
      resultElement = new audiencias.views.Result(audience: audience)
      resultElement.render()
      @$el.find('.results-list').append(resultElement.el)

  linkCreator: (page) ->
    paramList = ["pagina=#{page}"]
    searchOptions = audiencias.globals.results.options
    for key of searchOptions
      if key != 'pagina' and searchOptions[key]
        paramList.push("#{key}=#{searchOptions[key]}")
    params = paramList.join('&')
    "/buscar?#{params}"