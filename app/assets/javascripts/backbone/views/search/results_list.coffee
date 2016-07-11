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

  linkCreator: (newParams) ->
    paramList = []
    searchOptions = $.extend({}, audiencias.globals.results.options)
    searchOptions = $.extend(searchOptions, newParams)
    for key of searchOptions
      paramList.push("#{key}=#{searchOptions[key]}") if searchOptions[key]
    params = paramList.join('&')
    "/buscar?#{params}"