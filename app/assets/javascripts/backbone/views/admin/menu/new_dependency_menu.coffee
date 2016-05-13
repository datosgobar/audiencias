class audiencias.views.NewDependencyMenu extends Backbone.View
  id: 'new-dependency-menu'
  className: 'generic-menu hidden'
  template: JST["backbone/templates/admin/menu/new_dependency_menu"]

  render: ->
    console.log('new dependency menu')