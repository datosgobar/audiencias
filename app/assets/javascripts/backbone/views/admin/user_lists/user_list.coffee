class audiencias.views.UserList extends Backbone.View
  template: JST["backbone/templates/admin/menu/user_list"]
  userTemplate: JST["backbone/templates/admin/menu/user"]
  className: 'user-list'
  iconClass: 'operator'
  role: 'user'
  events:
    'click .add-user': 'showAddUserForm'
    'click .edit-user': 'showEditUserForm'
    'click .remove-user': 'markForRemove'

  initialize: (options) ->
    @showingForm = false
    @userMode = options.userMode || ''
    audiencias.globals.users.on('change add remove', @render)

  render: =>
    @$el.html(@template({
      title: @title
      showingForm: @showingForm
      userMode: @userMode
    }))
    if @showingForm
      userForm = new audiencias.views.UserForm(
        user: @formUser
        role: @role
      )
      userForm.render()
      userForm.on('cancel', @hideForm)
      userForm.on('done', @updateOrCreateUser)
      @$el.find('.form').html(userForm.el)
    else
      users = audiencias.globals.users.filter(@userFilter)
      userListEl = @$el.find('.users').html('')
      users.forEach( (user) =>
        userEl = $(@userTemplate(user)).addClass(@userMode)
        userEl.find('.user-icon').addClass(@iconClass)
        userListEl.append(userEl)
      )
      if users.length == 0
        @$el.addClass('empty')

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
      @hideForm()
    else 
      @confirmNewUser(user)

  confirmNewUser: (user) =>
    messageOptions = {
      icon: 'alert',
      confirmation: true,
      text: @confirmNewUserText,
      callback: {
        confirm: => @submitNewUser(user)
      }
    }
    message = new audiencias.views.ImportantMessage(messageOptions)