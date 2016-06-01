class audiencias.views.AudienceParticipantsSection extends Backbone.View
  template: JST["backbone/templates/operator/audience/participants"]
  events: 
    'change .participants-radio': 'toggleParticipantsForm'
    'click .edit-participant': 'editParticipant'
    'click .remove-participant': 'removeParticipant'

  initialize: (@options) ->
    @audience = @options.audience
    if @audience.get('participants') and @audience.get('participants').length > 0
      @audience.set('editingParticipants', true)
    @participantBeingEdited = @newParticipant()
    @audience.on('change', @render)

  render: =>
    @$el.html(@template(
      audience: @audience
    ))
    @setTooltips()

    if @audience.get('editingParticipants')
      participantsForm = new audiencias.views.AudienceParticipantsForm(
        audience: @audience
        participantBeingEdited: @participantBeingEdited
      )
      participantsForm.render()
      @$el.find('.participant-form').append(participantsForm.el)
      participantsForm.on('participantSubmitted', =>
        @participantBeingEdited = @newParticipant()
      )

  setTooltips: =>
    @$el.find('.participants-tooltip').tooltipster(
      content: "Si han participado de la audiencia más personas, debe aclararlo aquí."
      maxWidth: 250
      position: 'right'
      theme: 'tooltipster-light'
    )

  toggleParticipantsForm: =>
    editingParticipants = @$el.find('#yes-participants').is(':checked')
    @audience.set('editingParticipants', editingParticipants)

  newParticipant: =>
    { person: { country: 'Argentina' } }

  editParticipant: (e) =>
    participantId = $(e.currentTarget).data('participant-id')
    participantToEdit = _.find(@audience.get('participants'), (p) -> p.id == participantId )
    if participantToEdit
      @participantBeingEdited = participantToEdit
      @render()

  removeParticipant: (e) =>
    participantId = $(e.currentTarget).data('participant-id')
    data = { audience: { id: @audience.get('id') }, participant: { id: participantId } }
    $.ajax(
      url: '/intranet/eliminar_participante'
      method: 'POST'
      data: data
      success: (response) =>
        if response and response.success 
          @audience.set('participants', response.participants)
    )