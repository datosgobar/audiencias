class window.AdminLanding

  constructor: ->
    @listenEvents()

  listenEvents: ->
    $('#dependencies-tree').on('click', 'li.dependency', @dependenctySelected)
    $('#expand-all').on('click', @expandAll)
    $('#collapse-all').on('click', @collapseAll)

  dependenctySelected: (e) ->
    target = $(e.currentTarget)

    if target.hasClass('expanded')
      target.removeClass('expanded').addClass('collapsed')
      if target.next().hasClass('children')
        target.next().find('li.dependency').removeClass('expanded').addClass('collapsed')
    else
      target.removeClass('collapsed').addClass('expanded')

  expandAll: ->
    $('li.dependency').removeClass('collapsed').addClass('expanded')

  collapseAll: ->
    $('li.dependency').removeClass('expanded').addClass('collapsed')
