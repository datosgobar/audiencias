class window.DependenciesList

  constructor: ->
    @listenEvents()

  listenEvents: ->
    $('#dependencies-tree').on('click', 'li.dependency', @dependencySelected)
    $('#expand-all').on('click', @expandAll)
    $('#collapse-all').on('click', @collapseAll)
    $(window).on('search:show-results', @showSearchResults)
      .on('search:show-base-list', @showBaseList)

  dependencySelected: (e) =>
    target = $(e.currentTarget)

    if target.hasClass('expanded')
      if target.next().hasClass('children')
        target.next().find('li.dependency').removeClass('expanded').addClass('collapsed')
    target.toggleClass('expanded collapsed')

    unless target.hasClass('selected')
      $('li.dependency.selected').removeClass('selected')
      target.addClass('selected')
      
    dependencyId = target.data('dependency-id')
    $(window).trigger('dependency:selected', [dependencyId])

  expandAll: ->
    $('li.dependency').removeClass('collapsed').addClass('expanded')

  collapseAll: ->
    $('li.dependency').removeClass('expanded').addClass('collapsed')

  showSearchResults: (e, results) ->
    $('#base-list').addClass('hidden')
    resultsList = $('#results-list').removeClass('hidden').find('ul').html('')

    for result in results
      resultEl = $('<li class="dependency">')
        .data('dependency-id', result.id)
        .text(result.name)
        .prepend($('<i class="material-icons collapsed">chevron_right</i>'))
      resultsList.append(resultEl)

  showBaseList: (e) ->
    $('#base-list').removeClass('hidden')
    $('#results-list').addClass('hidden')