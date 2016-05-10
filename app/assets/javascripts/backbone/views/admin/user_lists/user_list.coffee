class audiencias.views.UserList extends Backbone.View
  template: JST["backbone/templates/admin/menu/user_list"]
  userTemplate: JST["backbone/templates/admin/menu/user"]
  className: 'user-list'
  events:
    'click .add-user': 'showNewUserForm'
    'click .add-new-user': 'addUserFromForm'
    'click .cancel-add-new-user': 'cancelNewUserForm'
    'click .edit-user': 'editUser'
    'click .cancel-edit-user': 'cancelEditUserForm'
    'click .save-edit-user': 'saveEditUser'
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

  editUser: (e) =>
    user = $(e.currentTarget).closest('.user').data('user')
    @showEditForm()
    @populateEditForm(user)

  populateEditForm: (user) =>
    @$el.find('.edit-user-form option[value="' + user.id_type + '"]').prop('selected', true)
    @$el.find('.edit-user-form .person-id-input').val(user.person_id)
    @$el.find('.edit-user-form .name-input').val(user.name)
    @$el.find('.edit-user-form .surname-input').val(user.surname)
    @$el.find('.edit-user-form .email-input').val(user.email)

  cancelEditUserForm: =>
    @showUserList()

  saveEditUser: =>

  removeModeOn: =>
    @showUserList()
    @$el.find('.user').addClass('removable')
    @hideAddUserImg()

  removeUser: (e) =>
    $(e.currentTarget).closest('.user').addClass('removed')

  showNewUserForm: =>
    @showCreateForm()
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
    @$el.find('.edit-user-form').addClass('hidden')

  showCreateForm: =>
    @$el.find('.users').addClass('hidden')
    @$el.find('.edit-user-form').addClass('hidden')
    @$el.find('.new-user-form').removeClass('hidden')
    @$el.find('.new-user-form input').val('')

  showEditForm: =>
    @$el.find('.users').addClass('hidden')
    @$el.find('.new-user-form').addClass('hidden')
    @$el.find('.edit-user-form').removeClass('hidden')

  validatePersonId: (person_id) ->
    !!parseInt(person_id) and parseInt(person_id) > 0

  validateName: (str) ->
    str.trim().length > 0

  validateEmail: (str) ->
    /[\w+\-.]+@[a-z\d\-.]+\.[a-z]+/i.test(str)