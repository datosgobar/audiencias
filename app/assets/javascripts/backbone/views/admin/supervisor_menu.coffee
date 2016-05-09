class audiencias.views.SupervisorMenu extends Backbone.View
  id: 'supervisor-menu'
  className: 'generic-menu'
  template: JST["backbone/templates/admin/supervisor_menu"]
  events: 
    'click .toggle-menu-icon': 'toggleTopMenu'
    'click #edit-supervisors': 'editSupervisors'
    'click #remove-supervisors': 'removeSupervisors'
    'click #add-dependency': 'addDependency'

  initialize: ->
    @supervisorList = new audiencias.views.SupervisorList

  render: ->
    @$el.html(@template())
    @supervisorList.render()
    @$el.find('.menu-lists').html(@supervisorList.el)

  show: =>
    @$el.removeClass('hidden')
    @supervisorList.loadSupervisors()

  toggleTopMenu: =>
    @$el.find('.toggle-menu-icon, .top-menu').toggleClass('hidden')