class audiencias.views.SupervisorList extends Backbone.View
  template: JST["backbone/templates/admin/menu/user_list"]
  userTemplate: JST["backbone/templates/admin/menu/user"]
  className: 'user-list'
  events:
    'click .add-user': 'showAddUserForm'
    'click .edit-user': 'showEditUserForm'
    'click .remove-user': 'markForRemove'

  initialize: (options) ->
    @showingForm = false
    @userMode = options.userMode
    audiencias.globals.users.on('change add remove', @render)

  render: =>
    @$el.html(@template({
      title: 'Supervisores'
      showingForm: @showingForm
      userMode: @userMode
    }))
    if @showingForm
      userForm = new audiencias.views.UserForm(
        user: @formUser
      )
      userForm.render()
      userForm.on('cancel', @hideForm)
      userForm.on('done', @updateOrCreateUser)
      @$el.find('.form').html(userForm.el)
    else
      users = audiencias.globals.users.filter( (u) -> u.get('role') == 'superadmin' )
      userListEl = @$el.find('.users').html('')
      users.forEach( (user) =>
        userEl = $(@userTemplate(user)).addClass(@userMode)
        userListEl.append(userEl)
      )

  showAddUserForm: =>
    @showingForm = true
    @formUser = null
    @render()

  showEditUserForm: (event) =>
    @showingForm = true
    userId = $(event.currentTarget).closest('.user').data('user-id')
    @formUser = audiencias.globals.users.get(userId)
    @render()

  markForRemove: (event) =>
    userId = $(event.currentTarget).closest('.user').data('user-id')
    user = audiencias.globals.users.get(userId)
    user.set('markedForRemoval', true)
    @render()

  hideForm: =>
    @showingForm = false
    @render()

  updateOrCreateUser: (user) =>
    if @formUser 
      user.set('markedForUpdate', true)
    else 
      @submitNewUser(user)
    @hideForm()

  submitNewUser: (user) ->
    $.ajax(
      url: '/intranet/nuevo_supervisor'
      data: { user: user.attributes }
      method: 'POST'
      success: (response) ->
        if response and response.user
          audiencias.globals.users.add(response.user)
    )

  submitChanges: =>
    requests = []
    usersForUpdate = audiencias.globals.users.filter( (user) -> user.get('markedForUpdate' ))
    usersForUpdate.forEach( (user) ->
      requests.push($.ajax(
        url: '/intranet/actualizar_usuario'
        data: { user: user.attributes }
        method: 'POST'
        success: (response) ->
          if response and response.user 
            user.set(response.user)
      ))
    )
    usersForRemoval = audiencias.globals.users.filter( (user) -> user.get('markedForRemoval' ))
    usersForRemoval.forEach( (user) ->
      requests.push($.ajax(
        url: '/intranet/eliminar_supervisor'
        data: { user: user.attributes } 
        method: 'POST'
        success: (response) ->
          if response and response.user 
            user.set(response.user)
      ))
    )