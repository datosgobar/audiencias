class audiencias.models.User extends Backbone.Model
  defaults: {
    id: null,
    name: '',
    surname: '',
    id_type: 'dni',
    person_id: null,
    email: '',
    role: 'operator'
  }

  initialize: ->
    @saveState()
    
  saveState: ->
    @lastSavedAttributes =  jQuery.extend(true, {}, @attributes)

  validate: ->
    validations = {
      name: @validateName()
      surname: @validateSurname(),
      'person-id': @validatePersonId(),
      email: @validateEmail()
    }
    valid = validations.name and validations.surname and validations['person-id'] and validations.email
    if valid 
      undefined 
    else 
      validations

  restore: =>
    @set(@lastSavedAttributes)

  validatePersonId: ->
    person_id = @get('person_id')
    !!parseInt(person_id) and parseInt(person_id) > 0

  validateName: ->
    name = @get('name')
    name.trim().length > 0 

  validateSurname: ->
    surname = @get('surname')
    surname.trim().length > 0

  validateEmail: ->
    email = @get('email')
    /[\w+\-.]+@[a-z\d\-.]+\.[a-z]+/i.test(email)