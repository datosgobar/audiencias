class audiencias.views.Form extends Backbone.View

  setPersonAutoComplete: (inputSelector, optionSelectCallback) =>
    input = @$el.find(inputSelector)
    input.autocomplete(
      source: @searchPerson
      select: (e, ui) ->
        if ui and ui.item and ui.item.person
          person = ui.item.person
          optionSelectCallback(person)
    )
    input.on('keyup', (e) =>
      if e.keyCode == 13
        @_doSearch = true
        input.autocomplete("search")
    )

  searchPerson: (autocompleteRequest, autocompleteCallback) =>
    return unless @_doSearch
    @_doSearch = false

    id_type = @$el.find('.id-type-input').val() # todo: tomar como parametro el selector
    person_id = autocompleteRequest.term
    
    $.ajax(
      url: '/buscar_persona'
      method: 'GET'
      data: { id_type: id_type, person_id: person_id }
      success: (response) =>
        wrappedPeople = @people2autocomplete(response)
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

  setAddressAutocomplete: (inputSelector, optionSelectCallback) =>
    input = @$el.find(inputSelector)
    input.autocomplete(
      source: @searchAddress
      select: (e, ui) ->
        if ui and ui.item and ui.item.address
          address = ui.item.address
          optionSelectCallback(address)
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
        wrappedAddress = _.collect(response.results, (a) -> 
          { label: a.full_address, address: a }
        )
        autocompleteCallback(wrappedAddress)
    )

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