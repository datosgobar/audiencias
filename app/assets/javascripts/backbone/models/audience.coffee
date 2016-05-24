#= require ./obligee
#= require ./person
class audiencias.models.Audience extends Backbone.Model
  defaults: {
    obligee: new audiencias.models.Obligee
    applicant: new audiencias.models.Person
    represented: null
  }

  initialize: ->