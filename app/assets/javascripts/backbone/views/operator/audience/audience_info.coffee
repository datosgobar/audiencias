class audiencias.views.AudienceInfoSection extends audiencias.views.Form
  template: JST["backbone/templates/operator/audience/main_info"]
  events:
    'click #edit-main-info': 'enableMainEdit'
    'click #edit-summary-info': 'enableSummaryEdit'
    'click #remove-main-info': 'removeMainInfo'
    'click #remove-summary-info': 'removeSummaryInfo'
    'click #confirm-main-info': 'submitChanges'

  initialize: (@options) ->
    @audience = @options.audience
    @audience.on('change', @render)

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
      @setMotifMaxLength()
      @setAddressAutocomplete('#address', @onAddressAutocompleteSelected)

  onAddressAutocompleteSelected: (address) =>
    @$el.find('#address').data('coordinates', true).data('lat', address.lat).data('lng', address.lng)

  setDatePicker: =>
    @$el.find('#date').datetimepicker(
      format: 'H:i d/m/Y'
      lazyInit: true
      minDate: '10/12/2015'
      formatDate:'d/m/Y'
      yearStart: 2015
      yearEnd: (new Date()).getFullYear()
      onClose: @validateDate
    )

  validateDate: =>
    newDate = @$el.find('#date').datetimepicker('getValue')
    year = newDate.getFullYear()
    month = newDate.getMonth() + 1
    day = newDate.getDate()
    if year < 2015 or (year == 2015 and (month < 12 or day < 10))
      @$el.find('#date').datetimepicker('reset')

  setMotifMaxLength: =>
    motifTextarea = @$el.find('#motif')
    motifTextarea.bind('input propertychange', =>
      maxLength = motifTextarea.attr('maxlength')
      if motifTextarea.val().length > maxLength
        cuttedText = motifTextarea.val().substring(0, maxLength)
        motifTextarea.val(cuttedText)
    )

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

    newSummary = @$el.find('#summary').val()
    if newSummary != @audience.get('summary')
      data.summary = newSummary 
      someThingChanged = true

    newInterestInvoked = @$el.find('#invoked-interest-select').val()
    if newInterestInvoked != @audience.get('interest_invoked')
      data.interest_invoked = newInterestInvoked 
      someThingChanged = true

    newMotif = @$el.find('#motif').val()
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
    if newAddress != @audience.get('address') and @$el.find('#address').data('coordinates')
      data.address = newAddress
      data.lat = @$el.find('#address').data('lat')
      data.lng = @$el.find('#address').data('lng')
      someThingChanged = true

    if someThingChanged
      callback = => @audience.set('editingInfo', false)
      @audience.submitEdition(data, callback)
    else
      @audience.set('editingInfo', false)

  isDate: (date) ->
    Object.prototype.toString.call(date) == "[object Date]" 