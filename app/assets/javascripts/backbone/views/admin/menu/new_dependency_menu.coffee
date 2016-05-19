class audiencias.views.NewDependencyMenu extends Backbone.View
  id: 'new-dependency-menu'
  className: 'generic-menu modifying'
  template: JST["backbone/templates/admin/menu/new_dependency_menu"]
  events: 
    'click #edit-title': 'editTitle'
    'click #confirm-edit-title': 'confirmTitle'
    'click #cancel': 'cancelNewDependency'
    'click #confirm-actions': 'confirmNewDependency'
    'keypress .title-input': 'onKeypress'

  initialize: (options) ->
    @initDependency(options)
    @editingTitle = true

  initDependency: (options) ->
    audiencias.globals.userDependencies.deselectAll()
    newDependencyAttributes = { selected: true, top: !options.parentId}
    newDependencyAttributes.parent_id = options.parentId if options.parentId
    @dependency = new audiencias.models.Dependency(newDependencyAttributes)
    @dependency.on('change', @render)
    audiencias.globals.userDependencies.add(@dependency)
    audiencias.globals.userDependencies.expandParents(@dependency)

  render: =>
    @$el.html(@template(
      dependency: @dependency
      editingTitle: @editingTitle
    ))

    userMode = if @dependency.get('obligee') then 'editable' else null
    @obligeeList = new audiencias.views.NewDependencyObligeeList({ dependency: @dependency, userMode: userMode })
    @obligeeList.render()
    @$el.find('.menu-lists').html(@obligeeList.el)
    @$el.find('.title-input').focus() if @editingTitle

  cancelNewDependency: =>
    audiencias.globals.userDependencies.removeAndUpdateParentOf(@dependency)
    $(window).trigger('hide-side-menu')

  editTitle: =>
    @editingTitle = true
    @render()

  confirmTitle: =>
    @editingTitle = false
    newTitle = @$el.find('.title-input').val().trim()
    @dependency.set('name', newTitle)
    @render()

  onKeypress: (e) =>
    @confirmTitle() if e.which == 13

  confirmNewDependency: =>
    messageOptions = {
      icon: 'alert',
      confirmation: true,
      text: {
        main: '¿Está seguro de generar una nueva subdependencia?'
        secondary: 'Recuerde que estos cambios afectan a la base de datos del sistema y no tienen modificación.'
      }
      callback: {
        confirm: @submitNewDependency
      }
    }
    message = new audiencias.views.ImportantMessage(messageOptions)

  submitNewDependency: =>
    data = {
      dependency: @dependency.attributes, 
      obligee: @dependency.get('obligee'),
      person: @dependency.get('obligee').person
    }
    $.ajax(
      url: '/intranet/nueva_dependencia'
      method: 'POST'
      data: data
      success: (response) =>
        if response and response.dependency
          audiencias.globals.userDependencies.forceUpdate(response.dependency)
          @cancelNewDependency()
          $(window).trigger('dependency-selected', response.dependency.id)
    )