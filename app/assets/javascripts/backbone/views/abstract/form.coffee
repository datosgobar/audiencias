class audiencias.views.Form extends Backbone.View
  autocompeteWrapper: JST["backbone/templates/operator/audience/autocomplete_wrapper"]

  setPersonAutoComplete: (inputSelector) =>
    input = @$el.find(inputSelector)
    return unless input.length > 0
    @wrapAutocompleteInput(input, 'person')
    input.autocomplete(
      source: @searchPerson
      select: (e, ui) ->
        if ui and ui.item and ui.item.person
          person = ui.item.person
          input.parent().addClass('value-selected').find('.selected-value').text(person.person_id)
          input.trigger('autocompleteperson', [person])
    )
    input.on('keyup', (e) =>
      if e.keyCode == 13
        @_doSearch = true
        input.autocomplete("search")
    )

  searchPerson: (autocompleteRequest, autocompleteCallback) =>
    return unless @_doSearch
    @_doSearch = false

    # todo: tomar como parametro los selectores
    if @$el.find('.id-type-input').length > 0
      country = 'Argentina'
      id_type = @$el.find('.id-type-input').val() 
    else 
      country = @$el.find('.countries-select').val()
      id_type = ''
    person_id = autocompleteRequest.term
    
    $.ajax(
      url: '/buscar_persona'
      method: 'GET'
      data: { id_type: id_type, person_id: person_id, country: country }
      success: (response) =>
        if response and response.success and response.results.length > 0
          wrappedPeople = @people2autocomplete(response.results)
          autocompleteCallback(wrappedPeople)
          @$el.find('.sintys-error').css('display', 'none')
        else 
          @$el.find('.sintys-error').css('display', 'block')
    )

  people2autocomplete: (peopleList) ->
    _.collect(peopleList, (person) -> 
      { 
        label: "#{person.person_id} #{person.name}", 
        value: person.person_id
        person: person 
      }
    )

  setAddressAutocomplete: (inputSelector) =>
    input = @$el.find(inputSelector)
    return unless input.length > 0
    @wrapAutocompleteInput(input, 'address')
    input.autocomplete(
      source: @searchAddress
      select: (e, ui) ->
        if ui and ui.item and ui.item.address
          address = ui.item.address
          input.parent().addClass('value-selected').find('.selected-value').text(address.full_address)
          input.trigger('autocompleteaddress', [address])
    )
    input.on('keyup', (e) =>
      if e.keyCode == 13
        @_doSearch = true
        input.autocomplete("search")
    )

  searchAddress: (autocompleteRequest, autocompleteCallback) =>
    return unless @_doSearch
    @_doSearch = false
    addressQuery = autocompleteRequest.term
    $.ajax(
      url: '/buscar_direccion'
      method: 'GET'
      data: { address: addressQuery }
      success: (response) =>
        if response and response.success
          wrappedAddress = _.collect(response.results, (a) -> 
            { label: a.full_address, address: a }
          )
          autocompleteCallback(wrappedAddress)
    )

  setEntityAutocomplete: (inputSelector) =>
    input = @$el.find(inputSelector)
    return unless input.length > 0
    @wrapAutocompleteInput(input, 'entity')
    input.autocomplete(
      source: @searchEntity
      select: (e, ui) ->
        if ui and ui.item and ui.item.entity
          entity = ui.item.entity
          input.parent().addClass('value-selected').find('.selected-value').text(entity.cuit)
          input.trigger('autocompleteentity', [entity])
    )
    input.on('keyup', (e) => 
      if e.keyCode == 13
        @_doSearch = true
        input.autocomplete('search')
    )

  searchEntity: (autocompleteRequest, autocompleteCallback) =>
    return unless @_doSearch
    @_doSearch = false
    entityQuery = autocompleteRequest.term
    $.ajax(
      url: '/buscar_persona_juridica'
      method: 'GET'
      data: { cuit: entityQuery }
      success: (response) =>
        if response and response.success
          wrappedEntities = _.collect(response.results, (e) ->
            { label: "#{e.cuit} #{e.name}", entity: e, value: e.cuit }
          )
          autocompleteCallback(wrappedEntities)
    )

  wrapAutocompleteInput: (input, target) =>
    wrapper = $(@autocompeteWrapper())
    input.after(wrapper)
    wrapper.append(input)
    wrapper.on('click', '.search-icon', => 
      @_doSearch = true
      input.autocomplete('search') 
    ).on('click', '.remove-icon', =>
      input.parent().removeClass('value-selected')
      input.val('')
      input.trigger('autocompleteremoved')
    )
    if target == 'address' and input.data('coordinates')
      input.parent().addClass('value-selected').find('.selected-value').text(input.val())
    else if input.val().length > 0
      input.parent().addClass('value-selected').find('.selected-value').text(input.val())

  validatePersonId: (person_id, country) ->
    if country == 'Argentina'
      !!parseInt(person_id) and parseInt(person_id) > 0
    else
      person_id.length > 0

  validateName: (name) ->
    name.trim().length > 0 

  validateEmail: (email) ->
    /[\w+\-.]+@[a-z\d\-.]+\.[a-z]+/i.test(email)

  validateCountry: (country) ->
    country == 'Argentina' or audiencias.globals.countries.indexOf(country) > -1

  setMaxLength: =>
    @$el.find('[maxlength]').each( (i, el) =>
      input = $(el)
      input.bind('input propertychange', =>
        maxLength = input.attr('maxlength')
        if input.val().length > maxLength
          cuttedText = input.val().substring(0, maxLength)
          input.val(cuttedText)
      )
    )
