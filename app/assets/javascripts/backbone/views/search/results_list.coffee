class audiencias.views.ResultsList extends Backbone.View
  id: 'results'
  template: JST["backbone/templates/search/results_list"]

  initialize: (options) ->
    @linkCreator = options.linkCreator

  render: ->

    viewingHistoric = !!audiencias.globals.results.options.historico
    currentPage = audiencias.globals.results.current_page
    if viewingHistoric
      records = audiencias.globals.results.old_audiences.records
      totalPages = audiencias.globals.results.old_audiences.total_pages
    else 
      records = audiencias.globals.results.audiences.records
      totalPages = audiencias.globals.results.audiences.total_pages

    if records.length > 0
      @$el.html(@template(
        linkCreator: @linkCreator
        currentPage: currentPage,
        totalPages: totalPages,
        viewingHistoric: viewingHistoric
      ))

      for audience in records
        resultElement = new audiencias.views.Result(audience: audience, historic: viewingHistoric)
        resultElement.render()
        @$el.find('.results-list').append(resultElement.el)

      facets = new audiencias.views.Facets(linkCreator: @linkCreator)
      facets.render()
      @$el.find('.facets-container').append(facets.el)
