class audiencias.views.UserList extends Backbone.View
  template: JST["backbone/templates/admin/menu/user_list"]
  userTemplate: JST["backbone/templates/admin/menu/user"]
  className: 'user-list'
  positionInForm: false
  events:
    'click .add-user': 'showNewUserForm'
    'click .add-new-user': 'addUserFromForm'
    'click .cancel-add-new-user': 'cancelNewUserForm'
    'click .edit-user': 'editUser'
    'click .cancel-edit-user': 'cancelEditUserForm'
    'click .save-edit-user': 'saveEditUser'
    'click .remove-user': 'removeUser'
    'change .id-type-select': 'setAutocomplete'

  initialize: ->
    @users = []
    $(window).on('globals:users:loaded', @setAutocompleteOptions)
      .on('globals:users:updated', @setAutocompleteOptions)

  render: ->
    @$el.html(@template(title: @title, positionInForm: @positionInForm))
    userList = @$el.find('.users').html('')
    for user in @users
      userEl = $(@userTemplate(user)).data('user', user)
      userList.append(userEl)
    @setAutocomplete()

  showUserList: =>
    @$el.find('.users').removeClass('hidden')
    @$el.find('.new-user-form, .edit-user-form').addClass('hidden')
  
  showAddUserImg: =>
    @$el.find('.user-list-title img').removeClass('hidden')

  hideAddUserImg: =>
    @$el.find('.user-list-title img').addClass('hidden')

  # ---- NEW USERS ----

  showNewUserForm: =>
    @hideAddUserImg()
    @$el.find('.users, .edit-user-form').addClass('hidden')
    @$el.find('.new-user-form').removeClass('hidden')
    @$el.find('.new-user-form input').val('')

  cancelNewUserForm: =>
    @showAddUserImg()
    @showUserList()

  addUserFromForm: =>
    console.log('needs override')

  # ---- EDIT USERS ----

  editModeOn: =>
    @editMode = 'on'
    @oldUsers = $.extend(true, [], @users)
    @$el.find('.user').addClass('editable')
    @hideAddUserImg()

  cancelEditMode: =>
    if @editMode == 'on'
      @editMode = 'off'
      @users = @oldUsers
      @render()

  editUser: (e) =>
    user = $(e.currentTarget).closest('.user').data('user')
    @showEditFormFor(user)
    @trigger('form-shown')

  saveEditUser: =>
    validation = @validateUser('.edit-user-form')
    if validation.valid
      @replaceUserElement(validation.data)

  replaceUserElement: (user) =>
    for userEl in @$el.find('.user')
      data = $(userEl).data('user')
      if data.id_type == user.id_type and data.person_id.toString() == user.person_id
        data.name = user.name
        data.surname = user.surname
        data.email = user.email
        data.position = user.position if user.position
        newUserEl = $(@userTemplate(data))
        newUserEl.data('user', data)
        newUserEl.addClass('editable edited')
        $(userEl).replaceWith(newUserEl)
    @trigger('form-hidden')
    @showUserList()

  cancelEditUserForm: =>
    @trigger('form-hidden')
    @showUserList()

  showEditFormFor: (user) =>
    @populateForm('.edit-user-form', user)
    @$el.find('.users').addClass('hidden')
    @$el.find('.new-user-form').addClass('hidden')
    @$el.find('.edit-user-form').removeClass('hidden')

  # ---- REMOVE USERS ----

  removeModeOn: =>
    @$el.find('.user').addClass('removable')
    @hideAddUserImg()

  cancelRemoveMode: =>
    @$el.find('.user').removeClass('removable')

  removeUser: (e) =>
    $(e.currentTarget).closest('.user').addClass('hidden removed')  

  # ---- UTILS ----

  populateForm: (formSelector, user) =>
    form = @$el.find(formSelector)
    form.find('option[value="' + user.id_type + '"]').prop('selected', true)
    form.find('.person-id-input').val(user.person_id)
    form.find('.name-input').val(user.name)
    form.find('.surname-input').val(user.surname)
    form.find('.email-input').val(user.email)
    form.find('.position-input').val(user.position)

  setAutocompleteOptions: =>
    @autocompleteOptions = { dni: [], le: [], lc: [] }
    for user in audiencias.globals.users
      @autocompleteOptions[user.id_type].push(
        value: user.person_id.toString()
        data: user
      )
    @setAutocomplete()

  setAutocomplete: =>
    if audiencias.globals.users and not @autocompleteOptions
      @setAutocompleteOptions()
      return
    if @autocompleteOptions and @$el.find('.new-user-form .id-type-select').length > 0
      id_type = @$el.find('.new-user-form .id-type-select').val().trim()
      @$el.find('.new-user-form .person-id-input').autocomplete(
        source: @autocompleteOptions[id_type]
        select: @autocompleteSelectedChange
        change: @autocompleteSelectedChange
      )

  autocompleteSelectedChange: (e, ui) =>
    if ui and ui.item
      user = ui.item.data
      @populateForm('.new-user-form', user)
      @$el.find('.new-user-form .disabled-if-found').prop('disabled', true)
    else
      @$el.find('.new-user-form .disabled-if-found').prop('disabled', false)

  validateUser: (formSelector) =>
    $form = @$el.find(formSelector)
    data = {
      id_type: $form.find('.id-type-select').val().trim(),
      person_id: $form.find('.person-id-input').val(),
      name: $form.find('.name-input').val().trim(),
      surname: $form.find('.surname-input').val().trim(),
      email: $form.find('.email-input').val().trim(),
    }
    
    idValid = @validatePersonId(data.person_id)
    $form.find('.person-id-input').toggleClass('invalid', !idValid)
    nameValid = @validateName(data.name)
    $form.find('.name-input').toggleClass('invalid', !nameValid)
    surnameValid = @validateName(data.surname)
    $form.find('.surname-input').toggleClass('invalid', !surnameValid)
    emailValid = @validateEmail(data.email)
    $form.find('.email-input').toggleClass('invalid', !emailValid)
    
    {
      valid: idValid and nameValid and surnameValid and emailValid,
      data: data 
    }

  submitChanges: =>
    if @$el.find('.user.removed').length > 0
      @submitRemove()
    else if @$el.find('.user.edited').length > 0
      @submitEdit()
    else
      @render()
