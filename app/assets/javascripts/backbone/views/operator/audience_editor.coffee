class audiencias.views.AudienceEditor extends Backbone.View
  id: 'audience-editor'
  template: JST["backbone/templates/operator/audience_editor"]

  initialize: ->
    @audience = new audiencias.models.Audience
    @audience.set('currentStep', 'participants')
    @audience.set('obligee', audiencias.globals.obligees.currentObligee())
    @audience.on('change', @render)

  render: =>
    @$el.html(@template(
      audience: @audience
    ))

    obligeeSection = new audiencias.views.AudienceObligeeSection(@audience)
    obligeeSection.render()
    @$el.find('#editor-sections').append(obligeeSection.el)

    applicantSection = new audiencias.views.AudienceApplicantSection(@audience)
    applicantSection.render()
    @$el.find('#editor-sections').append(applicantSection.el)