class audiencias.views.SearchForm extends Backbone.View
  className: 'search-content'
  template: JST["backbone/templates/search/search_form"]
  events:
    'keyup #search-text': 'searchOnEnter'
    'click #submit-search': 'searchIfQuery'
    'change #show-advance-search': 'showAdvanceSearch'

  initialize: (options) ->
    @linkCreator = options.linkCreator

  render: ->
    @$el.html(@template(linkCreator: @linkCreator))

    if audiencias.globals.results
      searchOptions = if audiencias.globals.results then audiencias.globals.results.options else {}
      dateFrom = if searchOptions.desde then moment(searchOptions.desde, 'DD-MM-YYYY') else null
      dateTo = if searchOptions.hasta then moment(searchOptions.hasta, 'DD-MM-YYYY') else null
      
    @dateFromPicker = audiencias.app.setDatepicker(@$el.find('#date-from')[0], dateFrom)
    @dateToPicker = audiencias.app.setDatepicker(@$el.find('#date-to')[0], dateTo)

  searchOnEnter: (e) =>
    @searchIfQuery() if e.keyCode == 13

  searchIfQuery: =>
    params = []

    searchText = @$el.find('#search-text').val().trim()
    if searchText.length > 0
      params.push("q=#{searchText}")

      if @$el.find('#search-person').is(':checked')
        params.push('buscar-persona=si')

      if @$el.find('#search-dependencies').is(':checked')
        params.push('buscar-pen=si')

      if @$el.find('#search-representation').is(':checked')
        params.push('buscar-representado=si')

      if @$el.find('#search-summary').is(':checked')
        params.push('buscar-textos=si')

    if @dateFromPicker.getDate() and @$el.find('#date-from').val().length > 0
      dateFrom = @dateFromPicker.getMoment().format('DD-MM-YYYY')
      params.push("desde=#{dateFrom}")

    if @dateToPicker.getDate() and @$el.find('#date-to').val().length > 0
      dateTo = @dateToPicker.getMoment().format('DD-MM-YYYY')
      params.push("hasta=#{dateTo}")
    
    searchParams = if params.length > 0 then "?#{params.join('&')}" else ''

    window.location.href = "/buscar#{searchParams}"
