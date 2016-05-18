class audiencias.collections.Users extends Backbone.Collection
  model: audiencias.models.User
  idAttribute: 'id'

  initialize: ->

  currentUser: ->
    if audiencias.globals.currentUser
      @get(audiencias.globals.currentUser)
    else
      null

  cancelChanges: =>
    @cancelEditions()
    @cancelRemovals()

  cancelEditions: =>
    @filter( (user) -> user.get('markedForUpdate') ).forEach( (user) -> user.restore() )

  cancelRemovals: =>
    @filter( (user) -> user.get('markedForRemoval') ).forEach( (user) -> user.set('markedForRemoval', false))

  updateUser: (newUser) =>
    savedUser = @get(newUser.id)
    if savedUser
      savedUser.set(newUser)
      savedUser.set('markedForRemoval', false)
      savedUser.set('markedForUpdate', false)
    else 
      @add(newUser)