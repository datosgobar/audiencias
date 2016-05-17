class audiencias.views.DependencyMenu extends Backbone.View
  id: 'dependency-menu'
  className: 'generic-menu hidden'
  template: JST["backbone/templates/admin/menu/dependency_menu"]
  events:
    'click .toggle-menu-icon': 'toggleTopMenu'
    'click #see-admins': 'showAdmins'
    'click #hide-admins': 'hideAdmins'
    'click #add-sub-dependency': 'triggerNewDependency'
    'click #edit-users': 'editDependencyAndUsers'
    'click #remove-users': 'removeDependencyOrUsers'
    'click #see-dependency-audiencees': 'goToObligeeAudiences'
    'click #cancel': 'cancelModifying'
    'click #confirm-actions': 'confirmActions'
    'click #edit-dependency': 'editDependencyName'
    'click #cancel-edit-dependency': 'cancelEditDependencyName'
    'click #confirm-edit-dependency': 'confirmEditDependencyName'

  initialize: ->

  refreshDependency: =>
    if @dependency
      newDependencyInfo = _.find(audiencias.globals.userDependencies, (d) => d.id == @dependency.id)
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
    @$el.find('.title-name').text(@dependency.name)

    @adminList.cancelEditMode()
    @obligeeList.cancelEditMode()
    @operatorList.cancelEditMode()

    @adminList.cancelRemoveMode()
    @obligeeList.cancelRemoveMode()
    @operatorList.cancelRemoveMode()

    @hideAdmins()

  toggleTopMenu: =>
    @$el.find('.toggle-menu-icon, .top-menu').toggleClass('hidden')

  showAdmins: =>
    @showButtons('#hide-admins')
    @adminList.showAdminList()

  hideAdmins: =>
    @showButtons('#see-admins')
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
    @showButtons('#edit-dependency')

  editDependencyName: =>
    messageOptions = {
      icon: 'alert',
      confirmation: true,
      text: {
        main: '¿Está seguro de que quiere editar el nombre de la dependencia?',
        secondary: 'Los cambios afectaran las audiencias ya cargadas y seran visibles al público.'
      },
      callback: {
        confirm: => 
          @$el.find('.title-name').addClass('hidden')
          @$el.find('.title-form').removeClass('hidden')
          @showButtons('#cancel-edit-dependency, #confirm-edit-dependency')
      }
    }
    new audiencias.views.ImportantMessage(messageOptions)

  cancelEditDependencyName: =>
    @$el.find('.title-name').removeClass('hidden')
    @$el.find('.title-form').addClass('hidden')
    @$el.find('.title-input').val(@$el.find('.title-name').text())
    @showButtons('#edit-dependency')

  confirmEditDependencyName: =>
    @$el.find('.title-name').removeClass('hidden')
    @$el.find('.title-form').addClass('hidden')
    @$el.find('.title-name').addClass('edited')
      .text(@$el.find('.title-input').val())
    @showButtons('#edit-dependency')

  removeDependencyOrUsers: =>
    @$el.addClass('modifying')
    @adminList.showAdminList()
    @adminList.removeModeOn()
    @obligeeList.removeModeOn()
    @operatorList.removeModeOn()
    @toggleTopMenu()
    @showButtons('#remove-dependency')
    
  goToObligeeAudiences: =>
    window.open('/audiencias/carga/' + @dependency.obligee.id, '_blank')

  confirmActions: =>
    messageOptions = {
      icon: 'alert',
      confirmation: true,
      text: {
        main: '¿Está seguro de que quiere aplicar los cambios?'
      },
      callback: {
        confirm: @submitChanges
      }
    }
    new audiencias.views.ImportantMessage(messageOptions)

  submitChanges: =>
    changes = []
    newName = @$el.find('.title-name').text()
    if newName != @dependency.name
      data = { dependency: { id: @dependency.id, name: newName}}
      changes.push($.ajax(
        url: '/administracion/actualizar_dependencia'
        data: data
        method: 'POST'
      ))
    changes = changes.concat(@adminList.submitChanges())
    changes = changes.concat(@obligeeList.submitChanges())
    changes = changes.concat(@operatorList.submitChanges())
    $.when(changes).done(@render)

  showButtons: (selector) =>
    @$el.find('.title button').addClass('hidden')
    @$el.find(selector).removeClass('hidden')
    