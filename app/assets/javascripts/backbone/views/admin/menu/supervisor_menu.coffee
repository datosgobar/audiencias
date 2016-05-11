class audiencias.views.SupervisorMenu extends Backbone.View
  id: 'supervisor-menu'
  className: 'generic-menu hidden'
  template: JST["backbone/templates/admin/menu/supervisor_menu"]
  events: 
    'click .toggle-menu-icon': 'toggleTopMenu'
    'click #edit-supervisors': 'editSupervisors'
    'click #remove-supervisors': 'removeSupervisors'
    'click #add-dependency': 'addDependency'
    'click #cancel': 'defaultView'
    'click #confirm-actions': 'confirmActions'

  initialize: ->
    @supervisorList = new audiencias.views.SupervisorList

  render: ->
    @$el.html(@template())
    @supervisorList.render()
    @$el.find('.menu-lists').html(@supervisorList.el)

  toggleTopMenu: =>
    @$el.find('.toggle-menu-icon, .top-menu').toggleClass('hidden')

  editSupervisors: =>
    @$el.addClass('modifying')
    @supervisorList.editModeOn()
    @toggleTopMenu()

  removeSupervisors: =>
    @$el.addClass('modifying')
    @supervisorList.removeModeOn()
    @toggleTopMenu()

  addDependency: =>
    $(window).trigger('add-new-dependency')

  defaultView: =>
    @$el.removeClass('modifying')
    unless @$el.find('.top-menu').hasClass('hidden')
      @$el.find('.toggle-menu-icon, .top-menu').toggleClass('hidden')
    @supervisorList.defaultView()

  confirmActions: =>
    @supervisorList.submitChanges()
    @defaultView()