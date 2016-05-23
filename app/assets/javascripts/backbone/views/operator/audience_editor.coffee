class audiencias.views.AudienceEditor extends Backbone.View
  id: 'audience-editor'
  template: JST["backbone/templates/operator/audience_editor"]

  initialize: ->

  render: ->
    @$el.html(@template())
