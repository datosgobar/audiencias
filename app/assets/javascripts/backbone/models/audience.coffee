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


  submitEdition: (newData, callback) =>
    if @get('id')
      newData.id = @get('id')
    else
      newData.new = true
      newData.obligee_id = audiencias.globals.obligees.currentObligee().get('id')
      newData.author_id = audiencias.globals.users.currentUser().get('id')

    $.ajax(
      url: '/intranet/editar_audiencia'
      method: 'POST'
      data: { audience: newData }
      success: (response) =>
        if response.success and response.audience
          unless @get('id')
            window.location.hash = "audiencia=#{response.audience.id}"
          @forceUpdate(response.audience)
          callback() if callback
    )