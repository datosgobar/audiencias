class audiencias.views.ExternalFooter extends Backbone.View
  id: 'external-footer'
  template: JST["backbone/templates/footers/external_footer"]

  render: ->
    @$el.html(@template())
