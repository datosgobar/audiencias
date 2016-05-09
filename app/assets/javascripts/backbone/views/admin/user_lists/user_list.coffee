class audiencias.views.UserList extends Backbone.View
  template: JST["backbone/templates/admin/user_list"]
  userTemplate: JST["backbone/templates/admin/user"]
  className: 'user-list'
  events:
    'click .add-user': 'showNewUserForm'
    'click .add-new-user': 'addUserFromForm'
    'click .cancel-add-new-user': 'cancelNewUserForm'
    'click .edit-user': 'editUser'
    'click .remove-user': 'removeUser'

  render: ->
    @$el.html(@template({
      title: @title  
    }))

  renderUsers: (users) =>
    userList = @$el.find('.users').html('')
    for user in users
      userEl = $(@userTemplate(user))
      userEl.data('user', user)
      userList.append(userEl)

  editModeOn: =>
    @showUserList()
    @$el.find('.user').addClass('editable')
    @hideAddUserImg()

  editUser: =>

  removeModeOn: =>
    @showUserList()
    @$el.find('.user').addClass('removable')
    @hideAddUserImg()

  removeUser: (e) =>
    $(e.currentTarget).closest('.user').addClass('removed')

  showNewUserForm: =>
    @showForm()
    @hideAddUserImg()

  addUserFromForm: (e) =>

  cancelNewUserForm: =>
    @showUserList()
    @showAddUserImg()

  showAddUserImg: =>
    @$el.find('.user-list-title img').removeClass('hidden')

  hideAddUserImg: =>
    @$el.find('.user-list-title img').addClass('hidden')

  showUserList: =>
    @$el.find('.users').removeClass('hidden')
    @$el.find('.new-user-form').addClass('hidden')

  showForm: =>
    @$el.find('.users').addClass('hidden')
    @$el.find('.new-user-form').removeClass('hidden')
    @$el.find('.new-user-form input').val('')

  validateId: (id) ->
    !!parseInt(id) and parseInt(id) > 0

  validateName: (str) ->
    str.trim().length > 0

  validateEmail: (str) ->
    /[\w+\-.]+@[a-z\d\-.]+\.[a-z]+/i.test(str)