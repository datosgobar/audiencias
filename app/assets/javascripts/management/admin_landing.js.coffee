class window.AdminLanding

  constructor: (@dependencies) ->
    @listenEvents()

  listenEvents: ->
    $('#dependencies-tree').on('click', 'li.dependency', @dependenctySelected)
    $('#expand-all').on('click', @expandAll)
    $('#collapse-all').on('click', @collapseAll)

  dependenctySelected: (e) =>
    target = $(e.currentTarget)

    if target.hasClass('expanded')
      target.removeClass('expanded').addClass('collapsed')
      if target.next().hasClass('children')
        target.next().find('li.dependency').removeClass('expanded').addClass('collapsed')
    else
      target.removeClass('collapsed').addClass('expanded')

    unless target.hasClass('selected')
      $('li.dependency.selected').removeClass('selected')
      target.addClass('selected')
      dependencyId = target.data('dependency-id')
      @showMenu(dependencyId)

  expandAll: ->
    $('li.dependency').removeClass('collapsed').addClass('expanded')

  collapseAll: ->
    $('li.dependency').removeClass('expanded').addClass('collapsed')

  showMenu: (dependencyId) ->
    dependency = _.find(@dependencies, (d) -> d.id == dependencyId ) 
    $('#dependencies-menu').text(dependency.name)