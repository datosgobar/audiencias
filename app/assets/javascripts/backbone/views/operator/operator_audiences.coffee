class audiencias.views.OperatorAudiences extends Backbone.View
  id: 'operator-audiences'
  template: JST["backbone/templates/operator/operator_audiences"]
  events: 
    'click .delete-audience': 'confirmDeleteAudience'
    'click .published': 'showPreview'
    'click .close-preview': 'closePreview'

  initialize: ->
    audiencias.globals.audiences.on('add change', @render)

  render: =>
    @$el.html(@template(
      audiences: JSON.parse(JSON.stringify(audiencias.globals.audiences))
    ))

  confirmDeleteAudience: (e) =>
    audienceId = $(e.currentTarget).data('audience-id')
    messageOptions = {
      icon: 'alert',
      confirmation: true,
      text: {
        main: '¿Está seguro de borrar la audiencia?'
        secondary: 'Recuerde que estos cambios afectan a la base de datos del sistema y no tienen modificación.'
      }
      callback: {
        confirm: =>
          @deleteAudience(audienceId)
      }
    }
    message = new audiencias.views.ImportantMessage(messageOptions)

  deleteAudience: (audienceId) =>
    $.ajax(
      url: '/intranet/eliminar_audiencia'
      method: 'POST'
      data: { audience: { id: audienceId } }
      success: (response) =>
        if response and response.success
          NProgress.start()
          location.reload()
    )

  showPreview: (e) =>
    audienceId = $(e.currentTarget).data('audience-id')
    audience = audiencias.globals.audiences.get(audienceId)
    clonedAudience = new audiencias.models.Audience 
    clonedAudience.forceUpdate
    audiencePreview = new audiencias.views.AudiencePreview(audience: audience)
    audiencePreview.render()
    @$el.find('.preview').removeClass('hidden')
    @$el.find('.preview-container').html(audiencePreview.el)

  closePreview: =>
    @$el.find('.preview').addClass('hidden')