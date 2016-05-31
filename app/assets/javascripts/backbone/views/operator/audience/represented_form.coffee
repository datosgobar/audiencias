class audiencias.views.AudienceRepresentedForm extends Backbone.View
  template: JST["backbone/templates/operator/audience/represented_form"]

  initialize: (options) ->
    @audience = options.audience

  render: =>
    @$el.html(@template(
      audience: @audience
    ))