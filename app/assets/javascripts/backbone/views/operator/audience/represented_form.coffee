class audiencias.views.AudienceRepresentedForm extends Backbone.View
  template: JST["backbone/templates/operator/audience/represented_form"]
  events: 
    'change .represented-type-radio': 'representedTypeChanged'

  initialize: (options) ->
    @audience = options.audience
    @initRepresented()
    applicant = @audience.get('applicant')
    applicant.on('change', @render)

  render: =>
    @$el.html(@template(
      audience: @audience
    ))
    @setTooltips()

    applicant = @audience.get('applicant')
    if applicant.get('represented_person')
      personForm = new audiencias.views.AudienceRepresentedApplicantForm(audience: @audience)
      personForm.render()
      @$el.find('.inner-form').append(personForm.el)
    else if applicant.get('represented_legal_entity')
      legalEntityForm = new audiencias.views.AudienceRepresentedEntityForm(audience: @audience)
      legalEntityForm.render()
      @$el.find('.inner-form').append(legalEntityForm.el)
    else if applicant.get('represented_state_organism')
      organismForm = new audiencias.views.AudienceRepresentedOrganismForm(audience: @audience)
      organismForm.render()
      @$el.find('.inner-form').append(organismForm.el)
    else if applicant.get('represented_people_group')
      groupForm = new audiencias.views.AudienceRepresentedGroupForm(audience: @audience)
      groupForm.render()
      @$el.find('.inner-form').append(groupForm.el)

  setTooltips: =>
    new audiencias.views.Tooltip(
      el: @$el.find('.entity-tooltip')
      content: @$el.find('.entity-tooltip-content').html()
      contentAsHTML: true
    )

    new audiencias.views.Tooltip(
      el: @$el.find('.organism-tooltip')
      content: @$el.find('.organism-tooltip-content').html()
      contentAsHTML: true
    )

    new audiencias.views.Tooltip(
      el: @$el.find('.group-tooltip')
      content: @$el.find('.group-tooltip-content').html()
      position: 'left'
      contentAsHTML: true
    )    

  initRepresented: =>
    applicant = @audience.get('applicant')
    hasRepresented = applicant.get('represented_person') || applicant.get('represented_legal_entity') || applicant.get('represented_state_organism') || applicant.get('represented_people_group')
    unless hasRepresented
      applicant.set('represented_person', { country: 'Argentina' }) 

  representedTypeChanged: =>
    applicant = @audience.get('applicant')

    if @$el.find('#represented-person').is(':checked')
      applicant.set('represented_person', { country: 'Argentina' }) 
      applicant.unset('represented_legal_entity')
      applicant.unset('represented_state_organism')
      applicant.unset('represented_people_group')

    else if @$el.find('#represented-entity').is(':checked')
      applicant.unset('represented_person') 
      applicant.set('represented_legal_entity', { country: 'Argentina' })
      applicant.unset('represented_state_organism')
      applicant.unset('represented_people_group')

    else if @$el.find('#represented-organism').is(':checked')
      applicant.unset('represented_person') 
      applicant.unset('represented_legal_entity')
      applicant.set('represented_state_organism', { country: 'Argentina' })
      applicant.unset('represented_people_group')

    else if @$el.find('#represented-group').is(':checked')
      applicant.unset('represented_person') 
      applicant.unset('represented_legal_entity')
      applicant.unset('represented_state_organism')
      applicant.set('represented_people_group', { country: 'Argentina' })