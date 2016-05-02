class window.AdminEditor

  constructor: ->
    @listenEvents()

  listenEvents: ->
    $('#superadmin-options').on('click', @showAdminMenu)

  showAdminMenu: =>
    $('#dependencies-menu').addClass('hidden')
    $('#admin-menu').removeClass('hidden')
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
      adminEl = $('<li class="user">')
      userIcon = $('<span class="user-icon">').text((admin.name[0] + admin.surname[0]).toUpperCase())
      userName = $('<div class="user-name">').text("#{admin.name} #{admin.surname}")
      userDocument = $('<div class="user-document">').text(admin.dni)
      userEmail = $('<div class="user-email">').text(admin.email)
      
      adminEl.append(userIcon)
      adminEl.append(userName)
      adminEl.append(userDocument)
      adminEl.append(userEmail)

      adminList.append(adminEl)
