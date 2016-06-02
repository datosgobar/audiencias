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
    entityContent = '<p style="margin: 0">Un organismo, organización, asociación, empresa o institución que posea personería jurídica. <span style="font-style: italic">Ej: Fundación Greenpeace Argentina.</span></p>'
    @$el.find('.entity-tooltip').tooltipster(
      content: entityContent
      maxWidth: 250
      position: 'right'
      theme: 'tooltipster-light'
      contentAsHTML: true
    )

    organismContent = '<p style="margin: 0">Organismo, entidad, empresa, sociedad, dependencia u otro ente dentro del Estado.</p>'
    @$el.find('.organism-tooltip').tooltipster(
      content: organismContent
      maxWidth: 250
      position: 'right'
      theme: 'tooltipster-light'
      contentAsHTML: true
    )

    groupContent = '<p style="margin: 0">Colectivo o grupo de personas físicas que no poseen personería jurídica. <span style="font-style: italic">Ej: Un grupo de vecinos.</span></p>'
    @$el.find('.group-tooltip').tooltipster(
      content: groupContent
      maxWidth: 250
      position: 'left'
      theme: 'tooltipster-light'
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