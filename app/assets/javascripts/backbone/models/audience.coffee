#= require ./obligee
#= require ./person
#= require ./user
class audiencias.models.Audience extends Backbone.Model

  initialize: ->
    author = new audiencias.models.User(@get('author'))
    @set('author', author)

  forceUpdate: (newAudience) =>
    if newAudience.obligee and @get('obligee')
      @get('obligee').set(newAudience.obligee)
    else if newAudience.obligee
      @set('obligee', new audiencias.models.Obligee(newAudience.obligee))
    delete newAudience.obligee

    if newAudience.applicant and @get('applicant')
      @get('applicant').set(newAudience.applicant)
    else if newAudience.applicant
      @set('applicant', new audiencias.models.Applicant(newAudience.applicant))
    delete newAudience.applicant

    if newAudience.author and @get('author')
      @get('author').set(newAudience.author)
    else if newAudience.author
      @set('author', new audiencias.models.User, newAudience.author)
    delete newAudience.author

    @set(newAudience)