class audiencias.collections.Obligees extends Backbone.Collection
  model: audiencias.models.Obligee
  idAttribute: 'id'

  initialize: ->

  currentObligee: ->
    if audiencias.globals.currentObligee
      @get(audiencias.globals.currentObligee)
    else
      null