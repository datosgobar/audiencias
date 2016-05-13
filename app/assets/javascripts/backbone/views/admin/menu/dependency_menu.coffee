class audiencias.views.DependencyMenu extends Backbone.View
  id: 'dependency-menu'
  className: 'generic-menu hidden'
  template: JST["backbone/templates/admin/menu/dependency_menu"]
  events:
    'click .toggle-menu-icon': 'toggleTopMenu'
    'click #see-admins': 'showAdmins'
    'click #hide-admins': 'hideAdmins'
    'click #add-sub-dependency': 'triggerNewDependency'
    'click #edit-supervisors': 'editDependencyAndUsers'
    'click #remove-supervisors': 'removeDependencyOrUsers'
    'click #see-dependency-audiencees': 'goToObligeeAudiences'
    'click #cancel': 'cancelModifying'
    'click #confirm-actions': 'confirmActions'

  initialize: ->
    $(window).on('globals:dependencies:loaded', @refreshDependency)

  refreshDependency: =>
    if @dependency
      newDependencyInfo = _.find(audiencias.globals.dependencies, (d) => d.id == @dependency.id)
      @setDependency(newDependencyInfo) if newDependencyInfo

  setDependency: (@dependency) ->
    @adminList = new audiencias.views.AdminList(@dependency)
    @obligeeList = new audiencias.views.ObligeeList(@dependency)
    @operatorList = new audiencias.views.OperatorList(@dependency)
    
    @adminList.on('form-shown', => @$el.addClass('with-form'))
    @adminList.on('form-hidden', => @$el.removeClass('with-form'))
    @obligeeList.on('form-shown', => @$el.addClass('with-form'))
    @obligeeList.on('form-hidden', => @$el.removeClass('with-form'))
    @operatorList.on('form-shown', => @$el.addClass('with-form'))
    @operatorList.on('form-hidden', => @$el.removeClass('with-form'))

  render: =>
    @$el.removeClass('modifying')
    @$el.html(@template(@dependency))
    
    @adminList.render()
    @obligeeList.render()
    @operatorList.render()
    
    @$el.find('.menu-lists').html(@adminList.el)
      .append(@obligeeList.el)
      .append(@operatorList.el)

  cancelModifying: ->
    @$el.removeClass('modifying')

    @adminList.cancelEditMode()
    @obligeeList.cancelEditMode()
    @operatorList.cancelEditMode()

    @adminList.cancelRemoveMode()
    @obligeeList.cancelRemoveMode()
    @operatorList.cancelRemoveMode()

    @$el.find('#remove-dependency, #edit-dependency').addClass('hidden')
    @hideAdmins()

  toggleTopMenu: =>
    @$el.find('.toggle-menu-icon, .top-menu').toggleClass('hidden')

  showAdmins: =>
    @$el.find('#see-admins').addClass('hidden')
    @$el.find('#hide-admins').removeClass('hidden')
    @adminList.showAdminList()

  hideAdmins: =>
    @$el.find('#see-admins').removeClass('hidden')
    @$el.find('#hide-admins').addClass('hidden')
    @adminList.hideAdminList()

  triggerNewDependency: =>
    $(window).trigger('add-new-dependency', [@dependency])

  editDependencyAndUsers: =>
    @$el.addClass('modifying')
    @adminList.showAdminList()
    @adminList.editModeOn()
    @obligeeList.editModeOn()
    @operatorList.editModeOn()
    @toggleTopMenu()
    @$el.find('#see-admins, #hide-admins, #remove-dependency').addClass('hidden')
    @$el.find('#edit-dependency').removeClass('hidden')

  removeDependencyOrUsers: =>
    @$el.addClass('modifying')
    @adminList.showAdminList()
    @adminList.removeModeOn()
    @obligeeList.removeModeOn()
    @operatorList.removeModeOn()
    @toggleTopMenu()
    @$el.find('#see-admins, #hide-admins, #edit-dependency').addClass('hidden')
    @$el.find('#remove-dependency').removeClass('hidden')

  goToObligeeAudiences: =>
    window.open('/administracion/sujeto_obligado/' + @dependency.obligee.id, '_blank')

  confirmActions: =>
    changes = []
    changes = changes.concat(@adminList.submitChanges())
    changes = changes.concat(@obligeeList.submitChanges())
    changes = changes.concat(@operatorList.submitChanges())
    $.when(changes).done(@render)
    