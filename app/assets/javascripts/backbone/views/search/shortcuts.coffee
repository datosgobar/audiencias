class audiencias.views.Shortcuts extends Backbone.View
  id: 'shortcuts'
  className: 'main-container'
  template: JST["backbone/templates/search/shortcuts"]

  render: ->
    @$el.html(@template(
      linkCreator: audiencias.app.linkCreator
    ))

    header = new audiencias.views.SubHeader
    header.render()
    @$el.find('.search-background-filter').prepend(header.el)

    footer = new audiencias.views.ExternalFooter
    footer.render()
    @$el.find('.with-external-footer').append(footer.el)