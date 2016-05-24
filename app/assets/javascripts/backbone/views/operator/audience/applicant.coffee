class audiencias.views.AudienceApplicantSection extends Backbone.View
  template: JST["backbone/templates/operator/audience/applicant"]
  events:
    'change .represented-radio': 'representedChanged'

  initialize: (@audience) ->
    @audience.get('applicant').on('change', @render)

  render: =>
    @$el.html(@template(
      audience: @audience
    ))

    if not @audience.get('applicant').get('confirmed')
      applicantForm = new audiencias.views.AudienceApplicantForm(@audience)
      applicantForm.render()
      @$el.find('#applicant-form').append(applicantForm.el)

  representedChanged: =>
    representedState = @$el.find('.represented-radio:checked').attr('id')
    if representedState == 'is-represented'
      @audience.set('represented', {})
    else
      @audience.unset('represented')
