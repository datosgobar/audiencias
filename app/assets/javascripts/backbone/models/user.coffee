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

  validatePersonId: ->
    person_id = @get('person_id')
    !!parseInt(person_id) and parseInt(person_id) > 0

  validateNames: ->
    name = @get('name')
    surname = @get('surname')
    name.trim().length > 0 and surname.trim().length > 0

  validateEmail: ->
    email = @get('email')
    /[\w+\-.]+@[a-z\d\-.]+\.[a-z]+/i.test(email)