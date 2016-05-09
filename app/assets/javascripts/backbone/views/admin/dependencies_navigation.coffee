class audiencias.views.DependenciesNavigation extends Backbone.View
  id: 'navigation'
  template: JST["backbone/templates/admin/dependencies_navigation"]
  events:
    'click #supervisor-menu-button': 'triggerShowMenu'

  render: ->
    @$el.html(@template())

  triggerShowMenu: ->
    $(window).trigger('menu:show-supervisor')