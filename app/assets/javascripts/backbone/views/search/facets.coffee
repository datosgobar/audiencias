class audiencias.views.Facets extends Backbone.View
  template: JST["backbone/templates/search/facet"]
  className: 'facets'
  events: 
    'click .expand-facet-list': 'expandFacetList'
    'click .collapse-facet-list': 'collapseFacetList'

  initialize: (options) ->
    @linkCreator = options.linkCreator

  render: ->
    aggregations = audiencias.globals.results.aggregations || {}
    options = audiencias.globals.results.options || {}
    selected = audiencias.globals.results.selected_values || {}

    if aggregations['_people'] or options['persona']
      @$el.append(@template(
        title: 'Personas'
        selectedValue: selected['person'],
        paramName: 'persona',
        facetList: if aggregations['_people'] then aggregations['_people'].ids.buckets else []
        linkCreator: @linkCreator
      ))

    if aggregations['_dependency'] or options['pen']
      @$el.append(@template(
        title: 'Poder Ejecutivo Nacional'
        selectedValue: selected['dependency'],
        paramName: 'pen',
        facetList: if aggregations['_dependency'] then aggregations['_dependency'].ids.buckets else []
        linkCreator: @linkCreator
      ))

    if aggregations['_interest_invoked'] or options['interes-invocado']
      @$el.append(@template(
        title: 'Interes Invocado'
        selectedValue: selected['interest_invoked'],
        paramName: 'interes-invocado',
        facetList: if aggregations['_interest_invoked'] then aggregations['_interest_invoked'].ids.buckets else []
        linkCreator: @linkCreator
      ))
    
  expandFacetList: (e) =>
    target = $(e.currentTarget)
    facetList = target.siblings('.facet-list.hidden')
    facetList.first().removeClass('hidden')
    if facetList.length == 1
      target.addClass('hidden')
      target.siblings('.collapse-facet-list').removeClass('hidden')

  collapseFacetList: (e) =>
    target = $(e.currentTarget).addClass('hidden')
    target.siblings('.expand-facet-list').removeClass('hidden')
    facetList = target.siblings('.facet-list')
    facetList.addClass('hidden')
    facetList.first().removeClass('hidden')
