class audiencias.views.AudienceInfoSection extends Backbone.View
  template: JST["backbone/templates/operator/audience/main_info"]

  initialize: (@audience) ->

  render: ->
    @$el.html(@template(
      audience: @audience
    ))