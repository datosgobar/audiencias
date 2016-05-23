class audiencias.views.AudienceEditor extends Backbone.View
  id: 'audience-editor'
  template: JST["backbone/templates/operator/audience_editor"]

  initialize: ->
    @currentStep = 'participants'
    audiencias.globals.obligees.on('change add', @render)

  render: =>
    @currentObligee = audiencias.globals.obligees.currentObligee()
    @$el.html(@template(
      currentStep: @currentStep
      obligee: @currentObligee
    ))
