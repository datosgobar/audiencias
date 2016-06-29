class audiencias.views.Searcher extends Backbone.View
  id: 'searcher'
  className: 'main-container'
  template: JST["backbone/templates/search/searcher"]
  events:
    'keyup #search-text': 'searchOnEnter'
    'click #submit-search': 'searchIfQuery'
    'change #search-old': 'changeSearchScope'
    'change #show-advance-search': 'showAdvanceSearch'

  render: ->
    @$el.html(@template())

    header = new audiencias.views.SubHeader
    header.render()
    @$el.find('.search-background-filter').prepend(header.el)

    footer = new audiencias.views.ExternalFooter
    footer.render()
    @$el.find('.with-external-footer').append(footer.el)

    shortcuts = new audiencias.views.SearchShortcuts
    shortcuts.render()
    @$el.find('.with-external-footer').append(shortcuts.el)

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
