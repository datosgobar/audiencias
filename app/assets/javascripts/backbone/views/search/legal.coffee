class audiencias.views.Legal extends Backbone.View
  id: 'legal' 
  className: 'main-container'
  template: JST["backbone/templates/search/legal"]

  render: ->
    @$el.html(@template())

    header = new audiencias.views.SubHeader
    header.render()
    @$el.find('.search-background-filter').prepend(header.el)

    footer = new audiencias.views.ExternalFooter
    footer.render()
    @$el.find('.with-external-footer').append(footer.el)