class audiencias.views.SupervisorMenu extends Backbone.View
  id: 'supervisor-menu'
  className: 'generic-menu'
  template: JST["backbone/templates/admin/menu/supervisor_menu"]
  events: {
    'click .toggle-menu-icon': 'toggleTopMenu'

    'click #edit-supervisors': 'editSupervisors'
    'click #remove-supervisors': 'removeSupervisors'
    'click #add-dependency': 'addDependency'
    
    'click #cancel': 'cancelEdition'
    'click #confirm-actions': 'confirmActions'
  }

  render: ->
    @$el.html(@template())
    @$el.toggleClass('modifying', !!@userMode)

    @supervisorList = new audiencias.views.SupervisorList(userMode: @userMode)
    @supervisorList.render()
    @$el.find('.menu-lists').html(@supervisorList.el)

  toggleTopMenu: =>
    @$el.find('.toggle-menu-icon, .top-menu').toggleClass('hidden')

  editSupervisors: =>
    @userMode = 'editable'
    @render()

  removeSupervisors: =>
    @userMode = 'removable'
    @render()

  addDependency: =>
    $(window).trigger('add-new-dependency')

  cancelEdition: =>
    @userMode = null
    audiencias.globals.users.cancelChanges()
    @render()

  confirmActions: =>
    @userMode = null
    @supervisorList.submitChanges()
    @render()
