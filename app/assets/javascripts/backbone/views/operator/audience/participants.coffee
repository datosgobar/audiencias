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

    if @audience.get('editingParticipants')
      participantsForm = new audiencias.views.AudienceParticipantsForm(
        participantBeingEdited: @participantBeingEdited
      )
      participantsForm.render()
      @$el.find('.participant-form').append(participantsForm.el)

  toggleParticipantsForm: =>
    editingParticipants = @$el.find('#yes-participants').is(':checked')
    @audience.set('editingParticipants', editingParticipants)

  newParticipant: =>
    { person: { country: 'Argentina' } }

  editParticipant: (e) =>
    participantId = $(e.currentTarget).data('participant-id')

  removeParticipant: =>
    participantId = $(e.currentTarget).data('participant-id')
    