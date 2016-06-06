class audiencias.views.Tooltip
  content: ''
  maxWidth: 250
  position: 'right'
  theme: 'tooltipster-light'
  contentAsHTML: false

  constructor: (options) ->
    $(options.el).tooltipster(
      content: options.content || @content
      maxWidth: options.maxWidth || @maxWidth
      position: options.position || @position
      theme: options.theme || @theme
      contentAsHTML: options.contentAsHTML || @contentAsHTML
    )
