class audiencias.views.SearchForm extends Backbone.View
  className: 'search-content'
  template: JST["backbone/templates/search/search_form"]
  events:
    'keyup #search-text': 'searchOnEnter'
    'click #submit-search': 'searchIfQuery'
    'change #search-old': 'changeSearchScope'
    'change #show-advance-search': 'showAdvanceSearch'

  render: ->
    # todo: si ya se realizó una busqueda, mostrar el setup de ésta
    @$el.html(@template())

  changeSearchScope: =>
    searchingOld = @$el.find('#search-old').is(':checked')
    @$el.find('.search-form').toggleClass('historic-search', searchingOld)

  showAdvanceSearch: =>
    showingAdvanceSearch = @$el.find('#show-advance-search').is(':checked')
    @$el.find('.date-container').toggleClass('invisible', !showingAdvanceSearch)

  searchOnEnter: (e) =>
    @searchIfQuery() if e.keyCode == 13

  searchIfQuery: =>
    searchText = @$el.find('#search-text').val().trim()
    if searchText.length > 0
      searchParams = "q=#{searchText}"

      searchType = if $('#search-old').is(':checked') then 'historico' else @$el.find('#search-type').val()
      searchParams += "&en=#{searchType}"

      dateFrom = false
      if dateFrom
        searchParams += "&desde=#{dateFrom}"

      dateTo = false 
      if dateTo 
        searchParams += "&hasta=#{dateTo}"

      window.location.href = "/buscar?#{searchParams}"
