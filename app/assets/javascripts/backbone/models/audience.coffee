#= require ./obligee
#= require ./person
#= require ./user
class audiencias.models.Audience extends Backbone.Model
  defaults: {
    obligee: new audiencias.models.Obligee
    applicant: new audiencias.models.Applicant
    author: new audiencias.models.User
    participants: []
    date: null,
    summary: ''
    interest_invoked: null,
    published: false,
    lat: null,
    lng: null,
    motif: ''
  }

  initialize: ->
    author = new audiencias.models.User(@get('author'))
    @set('author', author)