class audiencias.views.AudienceInfoSection extends Backbone.View
  template: JST["backbone/templates/operator/audience/main_info"]
  events:
    'click #edit-main-info': 'enableEdit'
    'click #confirm-main-info': 'submitChanges'

  initialize: (@audience) ->
    @audience.on('change', @render)

  render: =>
    @$el.html(@template(
      audience: @audience
    ))

  enableEdit: =>
    @audience.set('editingInfo', true)

  submitChanges: =>
    data = { id: @audience.get('id') }

    newSummary = @$el.find('#summary').val()
    data.summary = newSummary if newSummary != @audience.get('summary')

    newInterestInvoked = @$el.find('#invoked-interest-select').val()
    data.interest_invoked = newInterestInvoked if newInterestInvoked != @audience.get('interest_invoked')

    newMotif = @$el.find('#motif').val()
    data.motif = newMotif if newMotif != @audience.get('motif')

    $.ajax(
      url: '/intranet/editar_audiencia'
      method: 'POST'
      data: { audience: data }
      success: (response) =>
        if response.success and response.audience
          response.audience.editingInfo = false
          audiencias.globals.audiences.updateAudience(response.audience)
    )