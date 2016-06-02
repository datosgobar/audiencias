class audiencias.views.AudienceApplicantSection extends Backbone.View
  template: JST["backbone/templates/operator/audience/applicant"]
  events:
    'change .represented-radio': 'representedChanged'
    'click .edit-applicant': 'editApplicant'
    'click .remove-applicant': 'removeApplicant'
    'click .edit-represented': 'editRepresented'
    'click .remove-represented': 'removeRepresented'

  initialize: (@options) ->
    @audience = @options.audience
    @audience.on('change', @render)
    unless @audience.get('applicant')
      @audience.set({
        editingApplicant: true,
        applicant: new audiencias.models.Applicant
      })

  render: =>
    @$el.html(@template(
      audience: @audience
    ))

    if @audience.get('editingApplicant')
      applicantForm = new audiencias.views.AudienceApplicantForm(audience: @audience)
      applicantForm.render()
      @$el.find('#applicant-form').append(applicantForm.el)

    if @audience.get('editingRepresented')
      representedForm = new audiencias.views.AudienceRepresentedForm(audience: @audience)
      representedForm.render()
      @$el.find('#represented-form').append(representedForm.el)

  representedChanged: =>
    representedState = @$el.find('.represented-radio:checked').attr('id')
    if representedState == 'is-represented'
      @audience.set('editingRepresented', true)
    else
      @audience.unset('editingRepresented')
      applicant = @audience.get('applicant')
      applicant.unset('represented_person')
      applicant.unset('represented_legal_entity')
      applicant.unset('represented_state_organism')
      applicant.unset('represented_people_group')
      @render()

  editApplicant: =>
    @audience.set('editingApplicant', true)

  removeApplicant: =>
    @audience.set('editingApplicant', true)
    @audience.set('applicant', new audiencias.models.Applicant)

  editRepresented: =>
    @audience.set('editingRepresented', true)

  removeRepresented: =>
    data = { audience: { id: @audience.get('id') } }
    $.ajax(
      url: '/intranet/eliminar_representacion'
      method: 'POST'
      data: data
      success: (response) =>
        if response and response.success
          applicant = @audience.get('applicant')
          applicant.unset('represented_person')
          applicant.unset('represented_legal_entity')
          applicant.unset('represented_state_organism')
          applicant.unset('represented_people_group')
          applicant.set(response.applicant)
          @render()
    )