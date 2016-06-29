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
    @$el.find('.warning-message').toggleClass('invisible', !searchingOld)
    @$el.find('.advance-search').toggleClass('invisible', searchingOld)

  showAdvanceSearch: =>
    showingAdvanceSearch = @$el.find('#show-advance-search').is(':checked')
    @$el.find('.date-container').toggleClass('invisible', !showingAdvanceSearch)

  searchOnEnter: (e) =>
    @searchIfQuery() if e.keyCode == 13

  searchIfQuery: =>
    searchText = @$el.find('#search-text').val().trim()
    if searchText.length > 0
      window.location.href = "/buscar?q=#{searchText}"
