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

  toggleTopMenu: (e) =>
    @$el.find('.toggle-menu-icon, .top-menu').toggleClass('hidden')
    e.stopImmediatePropagation()
    e.preventDefault()
    if not @$el.find('.top-menu').hasClass('hidden')
      $(window).one('click', @toggleTopMenu)

  editSupervisors: =>
    @userMode = 'editable'
    @render()

  removeSupervisors: =>
    @userMode = 'removable'
    @render()

  addDependency: =>
    $(window).trigger('add-new-dependency', false)

  cancelEdition: =>
    @userMode = null
    audiencias.globals.users.cancelChanges()
    @render()

  confirmActions: =>
    messageOptions = {
      icon: 'alert',
      confirmation: true,
      text: {
        main: '¿Está seguro de los cambios que desea realizar?'
      }
      callback: {
        confirm: @submitActions
      }
    }
    message = new audiencias.views.ImportantMessage(messageOptions)

  submitActions: =>
    @userMode = null
    @supervisorList.submitChanges()
    @render()
