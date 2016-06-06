class audiencias.views.UserForm extends Backbone.View
  template: JST["backbone/templates/admin/menu/user_form"]
  className: 'user-form'
  events:
    'change .id-type-select': 'idTypeChanged'
    'click .cancel-user': 'cancel'
    'click .confirm-user': 'confirm'

  initialize: (options={}) ->
    @mode = if options.user then 'edit' else 'new'
    @user = options.user || new audiencias.models.User({ skipValidation: true })
    @user.on('change', @render)
    @userFound = false

  render: =>
    @$el.html(@template(
      user: @user
      mode: @mode
      userFound: @userFound
    ))
    @setAutocomplete() if @mode == 'new'

  cancel: =>
    @user.restore()
    @trigger('cancel')

  confirm: =>
    personIdValue = @$el.find('.person-id-input').val()
    person_id = parseInt(personIdValue.trim())
    @user.set(
      id_type: @$el.find('.id-type-select').val().trim(),
      person_id: if !!person_id then person_id else personIdValue,
      name: @$el.find('.name-input').val().trim(),
      email: @$el.find('.email-input').val().trim()
    )
    @user.unset('skipValidation')

    if @user.isValid()
      @trigger('done', @user)

  idTypeChanged: =>
    if @mode == 'new'
      @setAutocomplete()

  setAutocomplete: =>
    unless @autocompleteOptions
      dniUsers = audiencias.globals.users.filter( (user) -> user.get('id_type') == 'dni' )
      leUsers = audiencias.globals.users.filter( (user) -> user.get('id_type') == 'le' )
      lcUsers = audiencias.globals.users.filter( (user) -> user.get('id_type') == 'lc' )
      @autocompleteOptions = { 
        dni: _.map(dniUsers, (u) -> u.get('person_id').toString()), 
        le: _.map(leUsers, (u) -> u.get('person_id').toString()), 
        lc: _.map(lcUsers, (u) -> u.get('person_id').toString())
      }
    id_type = @$el.find('.id-type-select').val().trim()
    @$el.find('.person-id-input').autocomplete(
      source: @autocompleteOptions[id_type]
      select: @autocompleteSelectedChange
      change: @autocompleteSelectedChange
    )
  
  autocompleteSelectedChange: (e, ui) =>
    userQuery = { 
      id_type: @$el.find('.id-type-select').val().trim()
    }
    if ui and ui.item
      userQuery.person_id = parseInt(ui.item.value)
    else
      userQuery.person_id = parseInt(@$el.find('.person-id-input').val().trim())
    
    user = audiencias.globals.users.findWhere(userQuery)
    if user 
      @user.set(user.attributes)
      @userFound = true
      @render()
    else if @userFound
      @userFound = false
      userQuery.skipValidation = true
      @user.set(userQuery)
      @render()