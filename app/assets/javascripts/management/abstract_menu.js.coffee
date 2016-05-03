class window.AbstractMenu

  constructor: ->


  showTopMenu: =>
    $("#{@menuId} .top-menu").removeClass('hidden')
    $("#{@menuId} .cancel-top-action").addClass('hidden')

  showCancelAction: =>
    $("#{@menuId} .top-menu").addClass('hidden')
    $("#{@menuId} .cancel-top-action").removeClass('hidden')