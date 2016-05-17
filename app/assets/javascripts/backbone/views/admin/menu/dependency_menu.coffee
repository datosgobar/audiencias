class audiencias.views.DependencyMenu extends Backbone.View
  id: 'dependency-menu'
  className: 'generic-menu'
  template: JST["backbone/templates/admin/menu/dependency_menu"]
  events: {
    'click .toggle-menu-icon': 'toggleTopMenu'

    'click #add-sub-dependency': 'addSubNewDependency'
    'click #edit-users': 'editDependencyAndUsers'
    'click #remove-users': 'removeDependencyOrUsers'
    'click #see-dependency-audiencees': 'goToObligeeAudiences'

    'click #cancel': 'cancelEdition'
    'click #confirm-actions': 'submitChanges'

    'click #see-admins': 'showAdmins'
    'click #hide-admins': 'hideAdmins'
    'click #edit-dependency': 'editDependencyName'
    'click #cancel-edit-dependency': 'cancelEditDependencyName'
    'click #confirm-edit-dependency': 'confirmEditDependencyName'
  }

  initialize: (dependencyId) ->
    @dependency = audiencias.globals.userDependencies.get(dependencyId)
    @dependency.on('add change remove', @render)
    @renderMode = 'normal'
    @showingAdmins = false
    @editingTitle = false

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
    #@obligeeList = new audiencias.views.ObligeeList({ dependency: @dependency })
    #@operatorList = new audiencias.views.OperatorList({ dependency: @dependency })
    
    @adminList.render()
    @adminList.$el.toggleClass('hidden', !@showingAdmins)
    #@obligeeList.render()
    #@operatorList.render()
    
    @$el.find('.menu-lists')
      .html(@adminList.el)
     # .append(@obligeeList.el)
     # .append(@operatorList.el)

  toggleTopMenu: =>
    @$el.find('.toggle-menu-icon, .top-menu').toggleClass('hidden')

  editDependencyAndUsers: =>
    @renderMode = 'edit'
    @showingAdmins = true
    @render()

  removeDependencyOrUsers: =>
    @renderMode = 'remove'
    @showingAdmins = true
    @render()

  addSubNewDependency: =>

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
      @render()
    else
      @$el.find('.title-input').addClass('invalid')

  submitChanges: =>
    @renderMode = 'normal'
    @showingAdmins = true
    @editingTitle = false
    @adminList.submitChanges()
    #@obligeeList.submitChanges()
    #@operatorList.submitChanges()
    @submitDependencyChanges()
    @render()

  submitDependencyChanges: =>

  showAdmins: =>
    @showingAdmins = true
    @render()

  hideAdmins: =>
    @showingAdmins = false
    @render()

  triggerNewDependency: =>
    $(window).trigger('add-new-dependency', [@dependency])

  goToObligeeAudiences: =>
    window.open('/audiencias/carga/' + @dependency.obligee.id, '_blank')    