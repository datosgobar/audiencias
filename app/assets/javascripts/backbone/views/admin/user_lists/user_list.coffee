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
    'keypress .new-user-form .person-id-input': 'onIdInput'
    'focusout .new-user-form .person-id-input': 'searchUserFromInput'

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
    @populateForm('.edit-user-form', user)

  populateForm: (formSelector, user) =>
    form = @$el.find(formSelector)
    form.find('option[value="' + user.id_type + '"]').prop('selected', true)
    form.find('.person-id-input').val(user.person_id)
    form.find('.name-input').val(user.name)
    form.find('.surname-input').val(user.surname)
    form.find('.email-input').val(user.email)

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

  onIdInput: (e) =>
    @searchUserFromInput() if e.which == 13

  searchUserFromInput: =>
    searchPersonId = @$el.find('.new-user-form .person-id-input').val().trim()
    return if searchPersonId.length == 0
    searchIdType = @$el.find('.new-user-form .id-type-select').val().trim()
    $('body').addClass('searching')
    if (not @userForForm) or (searchPersonId != @userForForm.person_id) or (searchIdType != @userForForm.id_type)
      @$el.find('.new-user-form .disabled-when-searching').prop('disabled', true)
      $.ajax(
        url: '/administracion/buscar_usuario'
        data: { id_type: searchIdType, person_id: searchPersonId }
        method: 'POST'
        success: (response) =>
          @$el.find('.new-user-form .disabled-when-searching').prop('disabled', false)
          $('body').removeClass('searching')
          if response.user 
            @userForForm = response.user
            @populateForm('.new-user-form', @userForForm)
            @$el.find('.new-user-form .disabled-if-found').prop('disabled', true)
          else 
            @$el.find('input.disabled-if-found').val('')
            @$el.find('.new-user-form .name-input').focus()
      )
