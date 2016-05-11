class audiencias.views.DependencyMenu extends Backbone.View
  id: 'dependency-menu'
  className: 'generic-menu hidden'
  template: JST["backbone/templates/admin/menu/dependency_menu"]
  events:
    'click .toggle-menu-icon': 'toggleTopMenu'
    'click .toggle-admin-view': 'toggleAdmins'

  initialize: ->
    @adminList = new audiencias.views.AdminList
    @obligeeList = new audiencias.views.ObligeeList
    @operatorList = new audiencias.views.OperatorList

  defaultView: (dependency) ->
    @$el.html(@template(dependency))

    @adminList.render(dependency)
    @obligeeList.render(dependency)
    @operatorList.render(dependency)

    @$el.find('.menu-lists').html(@adminList.el)
      .append(@obligeeList.el)
      .append(@operatorList.el)

  toggleTopMenu: =>
    @$el.find('.toggle-menu-icon, .top-menu').toggleClass('hidden')

  toggleAdmins: =>
    @$el.find('.toggle-admin-view').toggleClass('hidden')
    @adminList.toggleShow()