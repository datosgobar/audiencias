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

  render: =>
    @$el.html(@template({
      title: @title
      showingForm: @showingForm
      userMode: @userMode
    }))
    if @showingForm
      userForm = new audiencias.views.ObligeeForm({ obligee: @dependency.get('obligee') })
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
    @render()

  showEditUserForm: =>
    messageOptions = {
      icon: 'info',
      confirmation: false,
      text: {
        main: '¿Está seguro de que desea editar al sujeto obligado actual?'
        secondary: 'La edición afectará las audiencas ya cargadas y los cambios serán visibles al público.\nPara cambiar el sujeto obligado asociado a la dependencia debe primero darlo de baja y luego agregar uno nuevo.'
      }
      callback: {
        confirm: =>
          @showingForm = true
          @render()
      }
    }
    message = new audiencias.views.ImportantMessage(messageOptions)

  markForRemove: =>
    obligeeData = @dependency.get('obligee')
    obligeeData.markedForRemoval = true
    @dependency.set('obligee', obligeeData)
    @render()

  hideForm: =>
    @showingForm = false
    @render()

  updateOrCreateUser: (obligee) =>
    if obligee and not obligee.id
      @confirmNewObligee(obligee)
    else if obligee
      obligee.markedForUpdate = true
      @dependency.set('obligee', obligee)
      @hideForm()

  confirmNewObligee: (obligee) =>
    messageOptions = {
      icon: 'alert',
      confirmation: true,
      text: {
        main: '¿Está seguro de que desea dar de alta al sujeto obligado?',
        secondary: 'El sujeto quedara registrado en la base de datos y será visible al público.'
      }
      callback: {
        confirm: => @submitNewObligee(obligee)
      }
    }
    message = new audiencias.views.ImportantMessage(messageOptions)

  submitNewObligee: (obligee) =>
    $.ajax(
      url: '/intranet/nuevo_sujeto_obligado'
      data: { dependency: @dependency.attributes, person: obligee.person, obligee: { position: obligee.position } }
      method: 'POST'
      success: (response) =>
        if response and response.dependency
          audiencias.globals.userDependencies.forceUpdate(response.dependency)
          @hideForm()
    )

  submitChanges: =>
    obligee = @dependency.get('obligee')
    return unless obligee
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