class audiencias.collections.Audiences extends Backbone.Collection
  model: audiencias.models.Audience
  idAttribute: 'id'

  initialize: ->

  currentAudience: ->
    if audiencias.globals.currentAudience
      @get(audiencias.globals.currentAudience)
    else
      null

  updateAudience: (newAudience) =>
    savedAudience = @get(newAudience.id)
    if savedAudience
      savedAudience.forceUpdate(newAudience)
    else 
      @add({id: newAudience.id})
      @updateAudience(newAudience)