class audiencias.views.DependencyMenu extends Backbone.View
  id: 'dependency-menu'
  className: 'generic-menu hidden'
  template: JST["backbone/templates/admin/menu/dependency_menu"]
  events:
    'click .toggle-menu-icon': 'toggleTopMenu'
    'click .toggle-admin-view': 'toggleAdmins'
    'click #add-sub-dependency': 'triggerNewDependency'

  initialize: ->
    $(window).on('globals:dependencies:loaded', @refreshDependency)

  refreshDependency: =>
    if @dependency
      newDependencyInfo = _.find(audiencias.globals.dependencies, (d) => d.id == @dependency.id)
      @defaultView(newDependencyInfo) if newDependencyInfo

  defaultView: (@dependency) ->
    @$el.html(@template(@dependency))
    @renderLists()

  renderLists: =>
    @adminList = new audiencias.views.AdminList(@dependency)
    @obligeeList = new audiencias.views.ObligeeList(@dependency)
    @operatorList = new audiencias.views.OperatorList(@dependency)
    
    @adminList.render()
    @obligeeList.render()
    @operatorList.render()

    @$el.find('.menu-lists').html(@adminList.el)
      .append(@obligeeList.el)
      .append(@operatorList.el)

  toggleTopMenu: =>
    @$el.find('.toggle-menu-icon, .top-menu').toggleClass('hidden')

  toggleAdmins: =>
    @$el.find('.toggle-admin-view').toggleClass('hidden')
    @adminList.toggleShow()

  triggerNewDependency: =>
    $(window).trigger('add-new-dependency', [@dependency])