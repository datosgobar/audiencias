class window.AdminDependenciesList

  constructore: ->
    @listenEvents()

  listenEvents: ->
    $('#dependencies-tree').on('click', 'li.dependency', @dependenctySelected)
    $('#expand-all').on('click', @expandAll)
    $('#collapse-all').on('click', @collapseAll)

  dependenctySelected: (e) =>
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