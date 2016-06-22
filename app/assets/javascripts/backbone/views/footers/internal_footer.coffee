class audiencias.views.InternalFooter extends Backbone.View
  id: 'intranet-footer'
  template: JST["backbone/templates/footers/internal_footer"]

  render: ->
    @$el.html(@template())