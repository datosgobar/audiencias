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
    $(window).on('globals:users:loaded', @setAutocompleteOptions)

  render: ->
    @$el.html(@template(title: @title, positionInForm: @positionInForm))

  renderUsers: =>
    userList = @$el.find('.users').html('')
    for user in @users
      userEl = $(@userTemplate(user))
      userEl.data('user', user)
      userList.append(userEl)

  editModeOn: =>
    @renderUsers()
    @$el.find('.user').addClass('editable')
    @hideAddUserImg()

  editUser: (e) =>
    user = $(e.currentTarget).closest('.user').data('user')
    @showEditForm()
    @trigger('hide-global-cancel')
    @populateForm('.edit-user-form', user)

  populateForm: (formSelector, user) =>
    form = @$el.find(formSelector)
    form.find('option[value="' + user.id_type + '"]').prop('selected', true)
    form.find('.person-id-input').val(user.person_id)
    form.find('.name-input').val(user.name)
    form.find('.surname-input').val(user.surname)
    form.find('.email-input').val(user.email)

  cancelEditUserForm: =>
    @trigger('show-global-cancel')
    @showUserList()

  removeModeOn: =>
    @renderUsers()
    @$el.find('.user').addClass('removable')
    @hideAddUserImg()

  removeUser: (e) =>
    $(e.currentTarget).closest('.user').addClass('hidden removed')

  showNewUserForm: =>
    @showCreateForm()
    @hideAddUserImg()

  cancelNewUserForm: =>
    @renderUsers()
    @showAddUserImg()
    @showUserList()

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
    
  setAutocompleteOptions: =>
    @autocompleteOptions = { dni: [], le: [], lc: [] }
    for user in audiencias.globals.users
      @autocompleteOptions[user.id_type].push(
        value: user.person_id.toString()
        data: user
      )
    @setAutocomplete()

  setAutocomplete: =>
    @setAutocompleteOptions() unless @autocompleteOptions
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