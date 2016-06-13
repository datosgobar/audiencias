class audiencias.views.AudienceEditor extends Backbone.View
  id: 'audience-editor'
  template: JST["backbone/templates/operator/audience_editor"]
  events: 
    'click #cancel-audience': 'backToList'
    'click #back-to-list': 'backToList'
    'click #go-to-info': 'goToInfo'
    'click #go-to-applicant': 'goToApplicant'
    'click #preview-audience': 'goToPreview'
    'click #modify-audience': 'goToApplicant'
    'click #publish-audience': 'confirmPublishAudience'
    'click .step': 'goToStep'

  initialize: ->
    @audience = audiencias.globals.audiences.currentAudience() || @newAudience()
    @audience.set('currentStep', 'applicant')
    @audience.set('obligee', audiencias.globals.obligees.currentObligee())
    @audience.on('change:id', @render)

  newAudience: ->
    audience = new audiencias.models.Audience({
      new: true
      editingInfo: true 
      editingApplicant: true
    })

  render: =>
    @$el.html(@template(
      audience: @audience
    ))

    if @audience.get('currentStep') == 'applicant'
      obligeeSection = new audiencias.views.AudienceObligeeSection(audience: @audience)
      obligeeSection.render()
      @$el.find('#editor-sections').append(obligeeSection.el)

      applicantSection = new audiencias.views.AudienceApplicantSection(audience: @audience)
      applicantSection.render()
      @$el.find('#editor-sections').append(applicantSection.el)

      participantsSection = new audiencias.views.AudienceParticipantsSection(audience: @audience)
      participantsSection.render()
      @$el.find('#editor-sections').append(participantsSection.el)

      missingFieldsSection = new audiencias.views.AudienceMissingFieldsMessage(audience: @audience)
      missingFieldsSection.render()
      @$el.find('#editor-sections').append(missingFieldsSection.el)

    else if @audience.get('currentStep') == 'info'

      mainInfoSection = new audiencias.views.AudienceInfoSection(audience: @audience)
      mainInfoSection.render()
      @$el.find('#editor-sections').append(mainInfoSection.el)

    else if @audience.get('currentStep') == 'preview'
      audiencePreview = new audiencias.views.AudiencePreview(audience: @audience)
      audiencePreview.render()
      @$el.find('#editor-sections').append(audiencePreview.el)

  backToList: =>
    obligeeId = audiencias.globals.currentObligee
    window.location.href = "/intranet/audiencias?sujeto_obligado=#{obligeeId}"

  goToInfo: =>
    @audience.set('currentStep', 'info')
    @render()

  goToApplicant: =>
    @audience.set('currentStep', 'applicant')
    @render()

  goToPreview: =>
    @audience.set('currentStep', 'preview')
    @render()

  goToStep: (e) =>
    stepTarget = $(e.currentTarget).data('step')
    unless $(e.currentTarget).hasClass('inactive')
      @audience.set('currentStep', stepTarget)
      @render()

  confirmPublishAudience: =>
    messageOptions = {
      icon: 'alert',
      confirmation: true,
      text: {
        main: '¿Está seguro de la audiencia que va a publicar?'
        secondary: 'Recuerde que si publica esta audiencia no hay forma de modificarla. Esta informacion reviste carácter de Declaración Jurada y es de acceso público.'
      }
      callback: {
        confirm: @publishAudience
      }
    }
    message = new audiencias.views.ImportantMessage(messageOptions)

  publishAudience: =>
    data = { audience: { id: @audience.get('id') } }
    $.ajax(
      url: '/intranet/publicar_audiencia'
      data: data
      method: 'POST'
      success: (response) =>
        if response and response.success 
          obligeeId = audiencias.globals.currentObligee
          window.location.href = "/intranet/audiencias?sujeto_obligado=#{obligeeId}"     
    )