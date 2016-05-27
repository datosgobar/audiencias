class audiencias.collections.Audiences extends Backbone.Collection
  model: audiencias.models.Audience
  idAttribute: 'id'

  initialize: ->
