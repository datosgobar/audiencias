class audiencias.views.AudienceApplicantForm extends Backbone.View
  template: JST["backbone/templates/operator/audience/applicant_form"]
  events: 
    'change .nationality-radio': 'nationalityChanged'
    'click .confirm-save': 'updateApplicant'

  initialize: (@audience) ->

  render: =>
    @$el.html(@template(audience: @audience))

  nationalityChanged: =>
    newCountry = @$el.find('.nationality-radio:checked').val()
    @audience.get('applicant').set('country', newCountry)
    @render()

  updateApplicant: =>
    applicant = @audience.get('applicant')
    newAttributes = {
      person_id: @$el.find('.person-id-input').val().trim()
      name: @$el.find('.name-input').val().trim()
      surname: @$el.find('.surname-input').val().trim()
      position: @$el.find('.position-input').val().trim()
      email: @$el.find('.email-input').val().trim()
      telephone: @$el.find('.telephone-input').val().trim()
      absent: @$el.find('#applicant-didnt-participated').is(':checked')
      editing: false
      confirmed: true
    }

    if applicant.get('country') == 'Argentina'
      newAttributes.id_type = @$el.find('.id-type-input').val()
    else
      newAttributes.country = @$el.find('.countries-select').val()

    applicant.set(newAttributes)
