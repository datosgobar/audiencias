class audiencias.views.SearchForm extends Backbone.View
  className: 'search-content'
  template: JST["backbone/templates/search/search_form"]
  events:
    'keyup #search-text': 'searchOnEnter'
    'click #submit-search': 'searchIfQuery'
    'change #search-old': 'changeSearchScope'
    'change #show-advance-search': 'showAdvanceSearch'

  render: ->
    @$el.html(@template())

    if audiencias.globals.results 
      dateFrom = moment(audiencias.globals.results.from, "DD-MM-YYYY")
      dateTo = moment(audiencias.globals.results.to, "DD-MM-YYYY")
    else
      dateFrom = null
      dateTo = null
    @dateFromPicker = @setDatepicker('#date-from', dateFrom)
    window.dateFromPicker = @dateFromPicker
    @dateToPicker = @setDatepicker('#date-to', dateTo)

  changeSearchScope: =>
    searchingOld = @$el.find('#search-old').is(':checked')
    @$el.find('.search-form').toggleClass('historic-search', searchingOld)

  showAdvanceSearch: =>
    showingAdvanceSearch = @$el.find('#show-advance-search').is(':checked')
    @$el.find('.date-container').toggleClass('invisible', !showingAdvanceSearch)

  searchOnEnter: (e) =>
    @searchIfQuery() if e.keyCode == 13

  searchIfQuery: =>
    searchText = @$el.find('#search-text').val().trim()
    if searchText.length > 0
      searchParams = "q=#{searchText}"

      searchType = if $('#search-old').is(':checked') then 'historico' else @$el.find('#search-type').val()
      searchParams += "&en=#{searchType}"

      dateFrom = @dateFromPicker.getMoment()
      if dateFrom
        searchParams += "&desde=#{dateFrom.format('DD-MM-YYYY')}"

      dateTo = @dateToPicker.getMoment() 
      if dateTo 
        searchParams += "&hasta=#{dateTo.format('DD-MM-YYYY')}"

      window.location.href = "/buscar?#{searchParams}"

  setDatepicker: (selector, selectedDate) ->
    i18n = {
      previousMonth : 'Mes anterior',
      nextMonth     : 'Mes siguiente',
      months        : ['Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre'],
      weekdays      : ['Domingo','Lunes','Martes','Miercoles','Jueves','Viernes','Sabado'],
      weekdaysShort : ['Dom','Lun','Mar','Mie','Jue','Vie','Sab']
    }
    picker = new Pikaday(
      field: @$el.find(selector)[0]
      format: 'DD-MM-YYYY'
      i18n: i18n,
      minDate: moment().date(1).month(0).year(2000).toDate()
      maxDate: moment().toDate()
    )
    picker.setMoment(selectedDate) if selectedDate
    picker