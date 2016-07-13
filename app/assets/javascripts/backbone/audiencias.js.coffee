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
          audiencias.globals.userDependencies.trigger('audiences:loaded')
      )

    loadUsers: ->
      $.ajax(
        url: '/intranet/listar_usuarios'
        method: 'GET'
        success: (response) =>
          audiencias.globals.users.set(response.users)
          audiencias.globals.users.trigger('users:loaded')
      )

    setDatepicker: (field, selectedDate) ->
      i18n = {
        previousMonth : 'Mes anterior',
        nextMonth     : 'Mes siguiente',
        months        : ['Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre'],
        weekdays      : ['Domingo','Lunes','Martes','Miercoles','Jueves','Viernes','Sabado'],
        weekdaysShort : ['Dom','Lun','Mar','Mie','Jue','Vie','Sab']
      }
      picker = new Pikaday(
        field: field
        format: 'DD-MM-YYYY'
        i18n: i18n,
        minDate: moment().date(1).month(0).year(2000).toDate()
        maxDate: moment().toDate()
      )
      picker.setMoment(selectedDate) if selectedDate
      picker      

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

    help: ->
      audiencias.app.init()
      @renderHeader()
      @render(audiencias.views.Help)

    legal: ->
      audiencias.app.init()
      @renderHeader()
      @render(audiencias.views.Legal)

    about: ->
      audiencias.app.init()
      @renderHeader()
      @render(audiencias.views.About)
      
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