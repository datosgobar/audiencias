class audiencias.views.AudienceMissingFieldsMessage extends Backbone.View
  template: JST["backbone/templates/operator/audience/missing_fields_message"]

  initialize: (options) ->
    @audience = options.audience
    @audience.on('change', @render)
    if @audience.get('applicant')
      @audience.get('applicant').on('change', @render)

  render: =>
    @$el.html(@template(
      audience: @audience
    ))