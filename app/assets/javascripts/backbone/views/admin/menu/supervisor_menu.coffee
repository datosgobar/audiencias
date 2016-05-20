class audiencias.views.SupervisorMenu extends Backbone.View
  id: 'supervisor-menu'
  className: 'generic-menu'
  template: JST["backbone/templates/admin/menu/supervisor_menu"]
  events: {
    'click .show-top-menu': 'showTopMenu'
    'click .hide-top-menu': 'hideTopMenu'
    
    'click #edit-supervisors': 'editSupervisors'
    'click #remove-supervisors': 'removeSupervisors'
    'click #add-dependency': 'addDependency'
    
    'click #cancel': 'cancelEdition'
    'click #confirm-actions': 'confirmActions'
  }

  render: ->
    @$el.html(@template())
    @$el.toggleClass('modifying', !!@userMode)
    @$el.find('.edit-veil').toggleClass('hidden', !@userMode)

    @supervisorList = new audiencias.views.SupervisorList(userMode: @userMode)
    @supervisorList.render()
    @$el.find('.menu-lists').html(@supervisorList.el)

  showTopMenu: (e) =>
    @$el.find('.show-top-menu').addClass('hidden')
    @$el.find('.hide-top-menu').removeClass('hidden')
    @$el.find('.top-menu').removeClass('hidden')
    e.preventDefault()
    e.stopImmediatePropagation()
    $(window).one('click', (e) =>
      unless $(e.target).hasClass('show-top-menu')
        @hideTopMenu()
    )

  hideTopMenu: (e) =>
    @$el.find('.show-top-menu').removeClass('hidden')
    @$el.find('.hide-top-menu').addClass('hidden')
    @$el.find('.top-menu').addClass('hidden')

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
