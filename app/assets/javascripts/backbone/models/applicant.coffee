#= require ./person
class audiencias.models.Applicant extends Backbone.Model
  defaults: {
    person: (new audiencias.models.Person).defaults
  }
