class audiencias.views.AudienceEditor extends Backbone.View
  id: 'audience-editor'
  template: JST["backbone/templates/operator/audience_editor"]

  initialize: ->
    @audience = audiencias.globals.audiences.currentAudience() || @newAudience()
    @audience.set('currentStep', 'participants')
    @audience.set('obligee', audiencias.globals.obligees.currentObligee())
    @audience.on('change', @render)

  newAudience: ->
    audience = new audiencias.models.Audience({
      new: true
      editingInfo: true 
      editingApplicant: true
    })
    audience.set('applicant', new audiencias.models.Applicant)

  render: =>
    @$el.html(@template(
      audience: @audience
    ))

    obligeeSection = new audiencias.views.AudienceObligeeSection(audience: @audience)
    obligeeSection.render()
    @$el.find('#editor-sections').append(obligeeSection.el)

    applicantSection = new audiencias.views.AudienceApplicantSection(audience: @audience)
    applicantSection.render()
    @$el.find('#editor-sections').append(applicantSection.el)

    participantsSection = new audiencias.views.AudienceParticipantsSection(audience: @audience)
    participantsSection.render()
    @$el.find('#editor-sections').append(participantsSection.el)

    mainInfoSection = new audiencias.views.AudienceInfoSection(audience: @audience)
    mainInfoSection.render()
    @$el.find('#editor-sections').append(mainInfoSection.el)