class audiencias.views.ResultsList extends Backbone.View
  id: 'results'
  template: JST["backbone/templates/search/results_list"]

  initialize: (options) ->
    @linkCreator = options.linkCreator

  render: ->
    viewingHistoric = audiencias.globals.results.options.historico

    if viewingHistoric and audiencias.globals.results.old_audiences.records.length > 0
      @$el.html(@template(
        linkCreator: @linkCreator
        currentPage: audiencias.globals.results.current_page,
        totalPages: audiencias.globals.results.old_audiences.total_pages
      ))

      facets = new audiencias.views.Facets(linkCreator: @linkCreator)
      facets.render()
      @$el.find('.facets-container').append(facets.el)

    else if audiencias.globals.results.audiences.records.length > 0
      @$el.html(@template(
        linkCreator: @linkCreator,
        currentPage: audiencias.globals.results.current_page,
        totalPages: audiencias.globals.results.audiences.total_pages
      ))

      for audience in audiencias.globals.results.audiences.records
        resultElement = new audiencias.views.Result(audience: audience)
        resultElement.render()
        @$el.find('.results-list').append(resultElement.el)

      facets = new audiencias.views.Facets(linkCreator: @linkCreator)
      facets.render()
      @$el.find('.facets-container').append(facets.el)
