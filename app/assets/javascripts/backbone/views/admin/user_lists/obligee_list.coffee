class audiencias.views.ObligeeList extends Backbone.View
  title: 'Sujeto obligado'
  template: JST["backbone/templates/admin/menu/user_list"]
  obligeeTemplate: JST["backbone/templates/admin/menu/obligee"]
  className: 'user-list'
  events:
    'click .add-user': 'showAddUserForm'
    'click .edit-user': 'showEditUserForm'
    'click .remove-user': 'markForRemove'

  initialize: (options) ->
    @showingForm = false
    @userMode = options.userMode || ''
    @dependency = options.dependency
    @newObligee = false

  render: =>
    @$el.html(@template({
      title: @title
      showingForm: @showingForm
      userMode: @userMode
    }))
    if @showingForm
      userForm = new audiencias.views.ObligeeForm({ dependency: @dependency, newObligee: @newObligee })
      userForm.render()
      userForm.on('cancel', @hideForm)
      userForm.on('done', @updateOrCreateUser)
      @$el.find('.form').html(userForm.el)
    else if @dependency.get('obligee')
      obligeeEl = $(@obligeeTemplate({dependency: @dependency})).addClass(@userMode)
      @$el.find('.users').html(obligeeEl)
      @$el.find('.add-user').addClass('hidden')

  showAddUserForm: =>
    @showingForm = true
    @newObligee = true
    @render()

  showEditUserForm: (event) =>
    @showingForm = true
    @newObligee = false
    @render()

  markForRemove: (event) =>
    obligeeData = @dependency.get('obligee')
    obligeeData.markedForRemoval = true
    @dependency.set('obligee', obligeeData)
    @render()

  hideForm: =>
    @showingForm = false
    @render()

  updateOrCreateUser: (user) =>
    if @newObligee
      @submitNewUser(user)
    else 
      obligeeData = @dependency.get('obligee')
      obligeeData.markedForUpdate = true
      @dependency.set('obligee', obligeeData)
    @hideForm()

  submitNewUser: (user) =>
    obligee = @dependency.get('obligee')
    $.ajax(
      url: '/intranet/nuevo_sujeto_obligado'
      data: { dependency: @dependency.attributes, person: obligee.person }
      method: 'POST'
      success: (response) ->
        if response and response.dependency
          audiencias.globals.userDependencies.forceUpdate(response.dependency)
    )

  submitChanges: =>
    obligee = @dependency.get('obligee')
    if obligee.markedForUpdate
      $.ajax(
        url: '/intranet/actualizar_sujeto_obligado'
        data: { dependency: @dependency.attributes, person: obligee.person, obligee: obligee }
        method: 'POST'
        success: (response) ->
          if response and response.dependency
            audiencias.globals.userDependencies.forceUpdate(response.dependency)
      )
    else if obligee.markedForRemoval
      $.ajax(
        url: '/intranet/eliminar_sujeto_obligado'
        data: { dependency: @dependency.attributes } 
        method: 'POST'
        success: (response) ->
          if response and response.dependency
            audiencias.globals.userDependencies.forceUpdate(response.dependency)
      )