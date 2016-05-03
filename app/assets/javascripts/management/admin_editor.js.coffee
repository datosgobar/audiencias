class window.AdminList

  constructor: ->
    @listenEvents()

  listenEvents: ->
    $('#superadmin-options').on('click', @showAdminMenu)
    $('#admin-menu .user-section-add').on('click', @showNewAdminForm)
    $('#admin-menu .cancel-top-action .cancel').on('click', @hideNewAdminForm)
    $('#submit-new-admin').on('click', @createNewAdmin)
    $('#remove-admin').on('click', @showRemoveIcons)
    $('#supervisors-list').on('click', '.user.removable', @removeAdmin)

  showAdminMenu: =>
    $('#dependencies-menu').addClass('hidden')
    $('#admin-menu').removeClass('hidden')
    @hideNewAdminForm()

  loadAdmins: =>
    if @admins 
      @showAdminList()
    else
      $.getJSON('/administracion/listar_supervisores', (response) =>
        @admins = response
        @showAdminList()
      )

  showAdminList: =>
    adminList = $('#supervisors-list').html('')
    for admin in @admins 
      adminEl = $('<li class="user">').data('dni', admin.dni)
      userIcon = $('<span class="user-icon">').text((admin.name[0] + admin.surname[0]).toUpperCase())
      removeIcon = $('<span class="user-icon remove-icon">').text('X')
      userName = $('<div class="user-name">').text("#{admin.name} #{admin.surname}")
      userDocument = $('<div class="user-document">').text(admin.dni)
      userEmail = $('<div class="user-email">').text(admin.email)
      
      adminEl.append(userIcon)
      adminEl.append(removeIcon)
      adminEl.append(userName)
      adminEl.append(userDocument)
      adminEl.append(userEmail)

      adminList.append(adminEl)

  showNewAdminForm: =>
    $('#admin-menu .top-menu').addClass('hidden')
    $('#admin-menu .cancel-top-action').removeClass('hidden')
    $('#supervisors-list').addClass('hidden')
    $('#new-admin-form').removeClass('hidden')
    $('#admin-menu .user-section-add').addClass('hidden')
    @cleanForm()

  hideNewAdminForm: =>
    $('#admin-menu .top-menu').removeClass('hidden')
    $('#admin-menu .cancel-top-action').addClass('hidden')
    $('#supervisors-list').removeClass('hidden')
    $('#new-admin-form').addClass('hidden')
    $('#admin-menu .user-section-add').removeClass('hidden')
    $('#admin-menu .user-section-remove').addClass('hidden')
    @loadAdmins()

  cleanForm: ->
    $('#new-admin-form input').val('')

  createNewAdmin: =>
    newAdminData = {
      dni: $('#new-admin-dni').val().trim(),
      name: $('#new-admin-name').val().trim()
      surname: $('#new-admin-surname').val().trim()
      email: $('#new-admin-email').val().trim()
    }
    $('#new-admin-form input, #new-admin-form button').prop('disabled', true)
    $.post('/administracion/nuevo_supervisor', newAdminData, @createNewAdminCallback)

  createNewAdminCallback: (response) =>
    if response and response.success
      @admins = null
      @hideNewAdminForm()

  showRemoveIcons: =>
    @hideNewAdminForm()
    $('#admin-menu .user-section-add').addClass('hidden')
    $('#admin-menu .user-section-remove').removeClass('hidden')
    $('#admin-menu .top-menu').addClass('hidden')
    $('#admin-menu .cancel-top-action').removeClass('hidden')
    $('#supervisors-list li.user').addClass('removable')

  removeAdmin: (e) =>
    data = {
      dni: $(e.currentTarget).data('dni')
    }
    $.post('/administracion/eliminar_supervisor', data, @removeAdminCallback)

  removeAdminCallback: (response) =>
    if response and response.success
      @admins = null
      @hideNewAdminForm()