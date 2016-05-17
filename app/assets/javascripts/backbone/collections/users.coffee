class audiencias.collections.Users extends Backbone.Collection
  model: audiencias.models.User
  idAttribute: 'id'

  initialize: ->

  currentUser: ->
    if audiencias.globals.currentUser
      @get(audiencias.globals.currentUser)
    else
      null