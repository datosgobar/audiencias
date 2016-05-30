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
      if newAudience.obligee
        savedAudience.get('obligee').set(newAudience.obligee)
        delete newAudience.obligee
      if newAudience.applicant
        savedAudience.get('applicant').set(newAudience.applicant)
        delete newAudience.applicant
      if newAudience.author
        savedAudience.get('author').set(newAudience.author)
        delete newAudience.author
      savedAudience.set(newAudience)
    else 
      @add(newAudience)