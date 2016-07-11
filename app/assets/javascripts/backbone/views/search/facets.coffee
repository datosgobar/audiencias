class audiencias.views.Facets extends Backbone.View
  template: JST["backbone/templates/search/facet"]
  className: 'facets'

  initialize: (options) ->
    @linkCreator = options.linkCreator

  render: ->
    aggregations = audiencias.globals.results.aggregations || {}
    options = audiencias.globals.results.options || {}

    if aggregations.people or options['persona']
      @$el.append(@template(
        title: 'Personas'
        selectedValue: options['persona'],
        paramName: 'persona',
        facetList: if aggregations.people then aggregations.people.buckets else []
        linkCreator: @linkCreator
      ))

    if aggregations.interest_invoked or options['interes-invocado']
      @$el.append(@template(
        title: 'Interes Invocado'
        selectedValue: options['interes-invocado'],
        paramName: 'interes-invocado',
        facetList: if aggregations.interest_invoked then aggregations.interest_invoked.buckets else []
        linkCreator: @linkCreator
      ))
    