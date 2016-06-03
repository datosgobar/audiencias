class audiencias.views.AudienceInfoSection extends Backbone.View
  template: JST["backbone/templates/operator/audience/main_info"]
  events:
    'click #edit-main-info': 'enableEdit'
    'click #confirm-main-info': 'submitChanges'

  initialize: (@options) ->
    @audience = @options.audience
    @audience.on('change', @render)

  render: =>
    @$el.html(@template(
      audience: @audience
    ))

    if @audience.get('editingInfo')
      @setTooltip()
      @setDatePicker()
      @setMotifMaxLength()

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

  setTooltip: =>
    content = '<p style="margin:0;font-weight: bold;">Tipo de interes</p>'
    content += '<p style="margin:0"><span style="font-weight: bold">Colectivo</span>: Se pretende influir en una decisión que afecta los derechos e intereses de un grupo de personas determinable. <span style="font-style: italic;">Ej: Modificar la normativa que regula ciertos procedimientos en el Colegio de Escribanos de CABA.</span></p>'
    content += '<p style="margin:0"><span style="font-weight: bold">Particular</span>: Se pretende influir en una decisión que afecta los derechos e intereses de una persona en particular. <span style="font-style: italic;">Ej: Conseguir fondos para la intervención quirúrgica de alta complejidad de un individuo.</span></p>'
    content += '<p style="margin:0"><span style="font-weight: bold">Difuso</span>: Se pretende influir en una decisión que afecta los derechos e intereses de un grupo de personas indeterminable. <span style="font-style: italic;">Ej: Regular los aumentos de precios del huevo, una materia prima utilizada por la industria y toda la ciudadanía. </span></p>'
    @$el.find('.interest-tooltip').tooltipster(
      content: content
      maxWidth: 400
      position: 'right'
      theme: 'tooltipster-light'
      contentAsHTML: true
    )

  enableEdit: =>
    @audience.set('editingInfo', true)

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
    if newAddress != @audience.get('address')
      data.address = newAddress
      someThingChanged = true

    if someThingChanged
      data.new = !!@audience.get('new')
      if data.new 
        data.obligee_id = audiencias.globals.obligees.currentObligee().get('id')
        data.author_id = audiencias.globals.users.currentUser().get('id')
      $.ajax(
        url: '/intranet/editar_audiencia'
        method: 'POST'
        data: { audience: data }
        success: (response) =>
          if response.success and response.audience
            response.audience.editingInfo = false
            response.audience.new = false
            @audience.forceUpdate(response.audience)
      )
    else
      @audience.set('editingInfo', false)

  isDate: (date) ->
    Object.prototype.toString.call(date) == "[object Date]" 