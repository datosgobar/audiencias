class audiencias.views.AudiencePreview extends Backbone.View
  template: JST["backbone/templates/operator/audience_preview"]
  className: 'audience-preview'

  initialize: (options) ->
    @audience = options.audience
    @hideMessages = options.hideMessages || false

  render: ->
    @$el.html(@template(
      audience: @audience
      hideMessages: @hideMessages
    ))  
