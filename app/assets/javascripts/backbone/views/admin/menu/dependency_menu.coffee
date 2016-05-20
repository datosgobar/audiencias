class audiencias.views.DependencyMenu extends Backbone.View
  id: 'dependency-menu'
  className: 'generic-menu'
  template: JST["backbone/templates/admin/menu/dependency_menu"]
  events: {
    'click .show-top-menu': 'showTopMenu'
    'click .hide-top-menu': 'hideTopMenu'

    'click #add-sub-dependency': 'addSubNewDependency'
    'click #edit-users': 'editDependencyAndUsers'
    'click #remove-users': 'removeDependencyOrUsers'
    'click #see-dependency-audiencees': 'goToObligeeAudiences'

    'click #cancel': 'cancelEdition'
    'click #confirm-actions': 'confirmChanges'

    'click #see-admins': 'showAdmins'
    'click #hide-admins': 'hideAdmins'
    'click #edit-dependency': 'editDependencyName'
    'click #cancel-edit-dependency': 'cancelEditDependencyName'
    'click #confirm-edit-dependency': 'confirmEditDependencyName'
    'click #remove-dependency': 'confirmRemoveDependency'
    'click .title-name': 'clickOnTitle'
  }

  initialize: (dependencyId) ->
    @dependency = audiencias.globals.userDependencies.get(dependencyId)
    @dependency.on('add change remove', @render)
    @renderMode = 'normal'
    @showingAdmins = false
    @editingTitle = false
    @titleEdited = false

  render: =>
    @$el.html(@template({
      dependency: @dependency
      showingAdmins: @showingAdmins
      renderMode: @renderMode
      editingTitle: @editingTitle
    }))
    @$el.toggleClass('modifying', @renderMode != 'normal')

    userMode = if @renderMode == 'remove' then 'removable' else if @renderMode == 'normal' then '' else 'editable'
    @adminList = new audiencias.views.AdminList({ dependency: @dependency, userMode: userMode })
    @obligeeList = new audiencias.views.ObligeeList({ dependency: @dependency, userMode: userMode })
    @operatorList = new audiencias.views.OperatorList({ dependency: @dependency, userMode: userMode })
    
    @adminList.render()
    @adminList.$el.toggleClass('hidden', !@showingAdmins)
    @obligeeList.render()
    @operatorList.render()
    
    @$el.find('.menu-lists')
      .html(@adminList.el)
      .append(@obligeeList.el)
      .append(@operatorList.el)

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

  editDependencyAndUsers: =>
    @renderMode = 'edit'
    @showingAdmins = true
    @render()

  removeDependencyOrUsers: =>
    @renderMode = 'remove'
    @showingAdmins = true
    @render()

  confirmRemoveDependency: =>
    messageOptions = {
      icon: 'alert',
      confirmation: true,
      text: {
        main: '¿Está seguro que desea dar de baja la dependencia?'
        secondary: 'El sujeto obligado, los usuarios y demas dependencias asociadas tambien seran dados de baja.'
      }
      callback: {
        confirm: @removeDependency
      }
    }
    message = new audiencias.views.ImportantMessage(messageOptions)

  removeDependency: =>
    $.ajax(
      url: '/intranet/eliminar_dependencia'
      method: 'POST'
      data: { dependency: @dependency.attributes }
      success: (response) =>
        if response and response.success
          audiencias.globals.userDependencies.removeAndUpdateParentOf(@dependency)
          $(window).trigger('hide-side-menu')
          messageOptions = {
            icon: 'info',
            confirmation: false
            text: {
              main: "Ha pasado a histórica la dependencia: #{response.dependency.name}"
              secondary: 'En consecuencia, los perfiles de usuario han sido desvinculados de esta dependencia.'
            }
          }
          message = new audiencias.views.ImportantMessage(messageOptions)
    )

  clickOnTitle: =>
    if @renderMode == 'edit'
      @editDependencyName()
    else if @renderMode == 'remove'
      @confirmRemoveDependency()

  addSubNewDependency: =>
    $(window).trigger('add-new-dependency', @dependency.get('id'))

  cancelEdition: =>
    @renderMode = 'normal'
    @editingTitle = false
    @showingAdmins = false
    audiencias.globals.users.cancelChanges()
    @dependency.restore()
    @render()

  editDependencyName: =>
    @editingTitle = true
    @render()

  cancelEditDependencyName: =>
    @editingTitle = false
    @render()

  confirmEditDependencyName: =>
    newName = @$el.find('.title-input').val().trim()
    if newName.length > 0
      @editingTitle = false
      @dependency.set('name', newName)
      @titleEdited = true
      @render()
    else
      @$el.find('.title-input').addClass('invalid')

  confirmChanges: =>
    messageOptions = {
      icon: 'alert',
      confirmation: true,
      callback: {
        confirm: @submitChanges
      }
    }
    message = new audiencias.views.ImportantMessage(messageOptions)

  submitChanges: =>
    @renderMode = 'normal'
    @showingAdmins = @dependency.get('users').length > 0
    @editingTitle = false
    @adminList.submitChanges()
    @obligeeList.submitChanges()
    @operatorList.submitChanges()
    @submitDependencyChanges()
    @render()

  submitDependencyChanges: =>
    if @titleEdited
      $.ajax(
        url: '/intranet/actualizar_dependencia'
        method: 'POST'
        data: { dependency: @dependency.attributes }
        success: (response) ->
          if response and response.dependency
            audiencias.globals.userDependencies.forceUpdate(response.dependency)
            @titleEdited = false
      )

  showAdmins: =>
    @showingAdmins = true
    @render()

  hideAdmins: =>
    @showingAdmins = false
    @render()

  goToObligeeAudiences: =>
    window.open('/audiencias/carga/' + @dependency.obligee.id, '_blank')    