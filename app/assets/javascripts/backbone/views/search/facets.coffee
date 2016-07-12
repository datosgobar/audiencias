class audiencias.views.Facets extends Backbone.View
  template: JST["backbone/templates/search/facet"]
  className: 'facets'

  initialize: (options) ->
    @linkCreator = options.linkCreator

  render: ->
    aggregations = audiencias.globals.results.aggregations || {}
    options = audiencias.globals.results.options || {}

    if aggregations['_people'] or options['persona']
      @$el.append(@template(
        title: 'Personas'
        selectedValue: options['persona'],
        paramName: 'persona',
        facetList: if aggregations['_people'] then aggregations['_people'].ids.buckets else []
        linkCreator: @linkCreator
      ))

    if aggregations['_dependency'] or options['pen']
      @$el.append(@template(
        title: 'Poder Ejecutivo Nacional'
        selectedValue: options['pen'],
        paramName: 'pen',
        facetList: if aggregations['_dependency'] then aggregations['_dependency'].ids.buckets else []
        linkCreator: @linkCreator
      ))

    if aggregations['_interest_invoked'] or options['interes-invocado']
      @$el.append(@template(
        title: 'Interes Invocado'
        selectedValue: options['interes-invocado'],
        paramName: 'interes-invocado',
        facetList: if aggregations['_interest_invoked'] then aggregations['_interest_invoked'].ids.buckets else []
        linkCreator: @linkCreator
      ))
    