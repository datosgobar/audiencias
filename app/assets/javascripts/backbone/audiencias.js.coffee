#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./collections
#= require_tree ./views

window.audiencias =
  views: {}
  models: {}
  collections: {}
  globals: {}
  app: {
    init: ->
      jQuery.datetimepicker.setLocale('es')
      $(document).ajaxStart(NProgress.start)
      $(document).ajaxStop(NProgress.done)
      audiencias.globals.userDependencies = new audiencias.collections.UserDependencies
      audiencias.globals.users = new audiencias.collections.Users
      audiencias.globals.obligees = new audiencias.collections.Obligees
      audiencias.globals.audiences = new audiencias.collections.Audiences
      new audiencias.views.UnexpectedErrorHandler
    
    loadDependencies: ->
      $.ajax(
        url: '/intranet/listar_dependencias'
        method: 'GET'
        success: (response) =>
          audiencias.globals.userDependencies.set(response.dependencies)
      )

    loadUsers: ->
      $.ajax(
        url: '/intranet/listar_usuarios'
        method: 'GET'
        success: (response) =>
          audiencias.globals.users.set(response.users)
      )

    render: (Class) ->
      instance = new Class
      instance.render()
      $('body').prepend(instance.el)

    renderHeader: ->
      @render(audiencias.views.Header)

    renderInternalFooter: ->
      @render(audiencias.views.InternalFooter)

    userLogin: ->
      audiencias.app.init()
      @renderHeader()
      @render(audiencias.views.UserLogin)

    sendPasswordReset: ->
      audiencias.app.init()
      @renderHeader()
      passwordReset = new audiencias.views.PasswordReset
      passwordReset.renderSendResetLink()
      $('body').append(passwordReset.el)

    updatePassword: (formOptions) ->
      audiencias.app.init()
      @renderHeader()
      passwordReset = new audiencias.views.PasswordReset
      passwordReset.renderUpdatePasswordForm(formOptions)
      $('body').append(passwordReset.el)

    adminLanding: ->
      audiencias.app.init()
      audiencias.app.loadDependencies()
      audiencias.app.loadUsers()
      @renderHeader()
      @renderInternalFooter()
      @render(audiencias.views.AdminLanding)

    operatorLanding: ->
      audiencias.app.init()
      @renderHeader()
      @renderInternalFooter()
      @render(audiencias.views.OperatorLanding)

    audienceEditor: ->
      @renderHeader()
      @renderInternalFooter()
      @render(audiencias.views.AudienceEditor)

    userConfig: ->
      audiencias.app.init()
      @renderHeader()
      @renderInternalFooter()
      userConfig = new audiencias.views.UserConfig
      $('body').append(userConfig.el)

    userHelp: ->
      audiencias.app.init()
      @renderHeader()
      @renderInternalFooter()
      @render(audiencias.views.UserHelp)

    userAbout: ->
      audiencias.app.init()
      @renderHeader()
      @renderInternalFooter()
      @render(audiencias.views.UserAbout)

    forbidden: ->
      audiencias.app.init()
      @renderHeader()
      @render(audiencias.views.Forbidden)

    notFound: ->
      audiencias.app.init()
      @renderHeader()
      @render(audiencias.views.NotFound)

    internalServerError: ->
      audiencias.app.init()
      @renderHeader()
      @render(audiencias.views.InternalServerError)

    searcher: ->
      audiencias.app.init()
      @renderHeader()
      @render(audiencias.views.Searcher)
      
  }
  helpers: {
    initials: (names) ->
      names = names.trim().split(' ')
      if names.length > 1
        initials = names[0][0] + names[1][0]
      else
        initials = names[0][0] + names[0][1]
      initials.toUpperCase()
  }