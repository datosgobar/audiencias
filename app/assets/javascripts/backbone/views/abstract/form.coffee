class audiencias.views.Form extends Backbone.View
  autocompeteWrapper: JST["backbone/templates/operator/audience/autocomplete_wrapper"]

  setPersonAutoComplete: (inputSelector) =>
    input = @$el.find(inputSelector)
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
      id_type = @$el.find('.id-type-input').val() 
    else 
      id_type = @$el.find('.countries-select').val()
    person_id = autocompleteRequest.term
    
    $.ajax(
      url: '/buscar_persona'
      method: 'GET'
      data: { id_type: id_type, person_id: person_id }
      success: (response) =>
        if response and response.success
          wrappedPeople = @people2autocomplete(response.results)
          autocompleteCallback(wrappedPeople)
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
          console.log('calling callback')
          autocompleteCallback(wrappedAddress)
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
    else if target == 'person' and input.val().length > 0
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