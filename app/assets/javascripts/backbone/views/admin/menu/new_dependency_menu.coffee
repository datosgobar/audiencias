class audiencias.views.NewDependencyMenu extends Backbone.View
  id: 'new-dependency-menu'
  className: 'generic-menu hidden'
  template: JST["backbone/templates/admin/menu/new_dependency_menu"]

  defaultView: ->
    console.log('new dependency menu')