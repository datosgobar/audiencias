class audiencias.views.AudienceRepresentedForm extends Backbone.View
  template: JST["backbone/templates/operator/audience/represented_form"]

  initialize: (options) ->
    @audience = options.audience

  render: =>
    @$el.html(@template(
      audience: @audience
    ))
    @setTooltips()

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