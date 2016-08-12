class audiencias.views.AudienceInfoSection extends audiencias.views.Form
  template: JST["backbone/templates/operator/audience/main_info"]
  events:
    'click #edit-main-info': 'enableMainEdit'
    'click #edit-summary-info': 'enableSummaryEdit'
    'click #remove-main-info': 'removeMainInfo'
    'click #remove-summary-info': 'removeSummaryInfo'
    'click #confirm-main-info': 'submitChanges'
    'autocompleteaddress #address': 'onAddressAutocompleteSelected'
    'autocompleteremoved #address': 'onAddressAutocompleteRemoved'

  initialize: (@options) ->
    @audience = @options.audience
    @audience.on('change', @render)
    dateThreshold = moment('2017/01/01')
    now = moment()
    if now.isAfter(dateThreshold) 
      limit = moment.duration(45, 'days')
      @minDate = now.subtract(limit)
    else 
      @minDate = moment('2015/12/10')

  render: =>
    @$el.html(@template(
      audience: @audience
    ))

    if @audience.get('editingInfo')
      new audiencias.views.Tooltip(
        el: @$el.find('.interest-tooltip')
        contentAsHTML: true
        content: @$el.find('.interest-tooltip-content').html()
        maxWidth: 400
      )
      @setDatePicker()
      @setMaxLength()
      @setAddressAutocomplete('#address')

  onAddressAutocompleteSelected: (e, address) =>
    @$el.find('#address').data('coordinates', true).data('lat', address.lat).data('lng', address.lng)

  onAddressAutocompleteRemoved: (e) =>
    @$el.find('#address').data('coordinates', false)

  setDatePicker: =>
    @$el.find('#date').datetimepicker(
      format: 'd/m/Y H:i'
      lazyInit: true
      minDate: @minDate.format('DD/MM/YYYY')
      formatDate:'d/m/Y'
      yearStart: 2015
      yearEnd: (new Date()).getFullYear()
      onClose: @validateDate
    )

  validateDate: =>
    newDate = @$el.find('#date').datetimepicker('getValue')
    if newDate and moment(newDate).isBefore(@minDate.subtract(moment.duration(1, 'day')))
      @$el.find('#date').datetimepicker('reset')

  enableMainEdit: =>
    @audience.set('editingInfo', true)

  enableSummaryEdit: =>
    @audience.set('editingInfo', true)

  removeMainInfo: =>
    data = { interest_invoked: '', motif: '', date: '', place: '', address: '' }
    @audience.submitEdition(data)

  removeSummaryInfo: =>
    data = { summary: '' }
    @audience.submitEdition(data)

  submitChanges: =>
    data = { id: @audience.get('id') }
    someThingChanged = false

    newSummary = @$el.find('#summary').val().trim()
    if newSummary != @audience.get('summary')
      data.summary = newSummary 
      someThingChanged = true

    newInterestInvoked = @$el.find('#invoked-interest-select').val()
    if newInterestInvoked != @audience.get('interest_invoked')
      data.interest_invoked = newInterestInvoked 
      someThingChanged = true

    newMotif = @$el.find('#motif').val().trim()
    if newMotif != @audience.get('motif')
      data.motif = newMotif 
      someThingChanged = true

    newDate = @$el.find('#date').datetimepicker('getValue')
    if @isDate(newDate)
      newDate = newDate.toISOString()
      data.date = newDate if newDate != @audience.get('date')
      someThingChanged = true

    newPlace = @$el.find('#place').val().trim()
    if newPlace != @audience.get('place')
      data.place = newPlace
      someThingChanged = true

    newAddress = @$el.find('#address').val().trim()
    if newAddress != @audience.get('address') 
      someThingChanged = true
      data.address = newAddress
      if @$el.find('#address').data('coordinates')
        data.lat = @$el.find('#address').data('lat')
        data.lng = @$el.find('#address').data('lng')
      else
        data.lat = null
        data.lng = null

    if someThingChanged
      callback = => @audience.set('editingInfo', false)
      @audience.submitEdition(data, callback)
    else
      @audience.set('editingInfo', false)

  isDate: (date) ->
    Object.prototype.toString.call(date) == "[object Date]" 