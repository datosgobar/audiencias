class audiencias.views.Facets extends Backbone.View
  dateTemaplte: JST["backbone/templates/search/date_filter"]
  facetTemplate: JST["backbone/templates/search/facet"]
  representationTemplate: JST["backbone/templates/search/facet_representation"]
  downloadTemplate: JST["backbone/templates/search/download_results"]
  className: 'facets'
  events: 
    'click .expand-facet-list': 'expandFacetList'
    'click .collapse-facet-list': 'collapseFacetList'
    'click .facet-group-name': 'toggleFacetGroup'
    'click .toggle-groups': 'toggleGroups'
    'click #apply-new-date': 'applyNewDate'

  initialize: (options) ->
    @linkCreator = options.linkCreator

  render: ->
    options = audiencias.globals.results.options || {}

    @$el.append(@dateTemaplte())
    @setDatepicker()

    @renderExpandedFacets() unless options.historico 
    #@renderDownload()

  renderExpandedFacets: =>
    aggregations = audiencias.globals.results.audiences.aggregations || {}
    selected = audiencias.globals.results.audiences.selected_values || {}

    @$el.append(@facetTemplate(
      title: 'Personas Físicas'
      selectedValue: selected['person'],
      paramName: 'persona',
      facetList: aggregations['_people']
      linkCreator: @linkCreator
    ))

    somethingSelected =  selected['organism'] or selected['group'] or selected['entity']
    hasOrganismFacets = aggregations['_represented_organism'] and aggregations['_represented_organism'].ids.buckets.length > 0
    hasGroupFacest = aggregations['_represented_group'] and aggregations['_represented_group'].ids.buckets.length > 0
    hasEntityFacets = aggregations['_represented_entity'] and aggregations['_represented_entity'].ids.buckets.length > 0
    hasFacets = hasOrganismFacets or hasGroupFacest or hasEntityFacets
    if somethingSelected or hasFacets
      @$el.append(@representationTemplate(
        title: 'En representación'
        aggregations: [{ 
          facetList: aggregations['_represented_organism'], 
          selected: selected['organism'], 
          paramName: 'organismo-estatal',
          name: 'Organismo Estatal'
        }, { 
          facetList: aggregations['_represented_group'], 
          selected: selected['group'], 
          paramName: 'grupo-de-personas',
          name: 'Grupo de personas'
        }, { 
          facetList: aggregations['_represented_entity'], 
          selected: selected['entity'], 
          paramName: 'persona-juridica',
          name: 'Personas Jurídicas'
        }],
        linkCreator: @linkCreator
      ))

    @$el.append(@facetTemplate(
      title: 'Poder Ejecutivo Nacional'
      selectedValue: selected['dependency'],
      paramName: 'pen',
      facetList: aggregations['_dependency']
      linkCreator: @linkCreator
    ))

    @$el.append(@facetTemplate(
      title: 'Interes Invocado'
      selectedValue: selected['interest_invoked'],
      paramName: 'interes-invocado',
      facetList: aggregations['_interest_invoked']
      linkCreator: @linkCreator
    ))
    
  renderDownload: ->
    @$el.append(@downloadTemplate())

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

  toggleFacetGroup: (e) =>
    target = $(e.currentTarget)
    target.find('i').toggleClass('hidden')
    target.siblings('.facet-group').toggleClass('hidden')

  toggleGroups: (e) =>
    target = $(e.currentTarget)
    target.parent().find('.toggle-groups').toggleClass('hidden')
    target.closest('.facet-section').find('.grouped-facet, .joined-facets').toggleClass('hidden')

  setDatepicker: =>
    searchOptions = audiencias.globals.results.options || {}
    dateFrom = if searchOptions.desde then moment(searchOptions.desde, 'DD-MM-YYYY') else null
    dateTo = if searchOptions.hasta then moment(searchOptions.hasta, 'DD-MM-YYYY') else null
      
    @dateFromPicker = audiencias.app.setDatepicker(@$el.find('#filter-date-from')[0], dateFrom)
    @dateToPicker = audiencias.app.setDatepicker(@$el.find('#filter-date-to')[0], dateTo)

  applyNewDate: =>
    newOptions = {}
    if @$el.find('#filter-date-from').val().length == 0
      newOptions.desde = null
    else if @dateFromPicker.getDate()
      dateFrom = @dateFromPicker.getMoment().format('DD-MM-YYYY')
      newOptions.desde = dateFrom

    if @$el.find('#filter-date-to').val().length == 0
      newOptions.hasta = null
    else if @dateToPicker.getDate() 
      dateTo = @dateToPicker.getMoment().format('DD-MM-YYYY')
      newOptions.hasta = dateTo
    window.location.href = @linkCreator(newOptions)