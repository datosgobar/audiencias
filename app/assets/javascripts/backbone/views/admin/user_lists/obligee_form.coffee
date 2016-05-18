class audiencias.views.ObligeeForm extends Backbone.View
  template: JST["backbone/templates/admin/menu/obligee_form"]
  className: 'user-form'
  events:
    'click .cancel-user': 'cancel'
    'click .confirm-user': 'confirm'

  initialize: (options={}) ->
    @newObligee = !options.obligee
    @obligee = options.obligee || @defaults()

  defaults: -> 
    { 
      position: '', 
      users: [], 
      skipValidation: true,
      person: { id_tpe: 'dni', person_id: '', name: '', surname: '', email: ''}
    }

  render: ->
    @$el.html(@template(
      newObligee: @newObligee
      obligee: @obligee
      validations: if @obligee.skipValidation then null else @validate()
    ))

  cancel: =>
    @trigger('cancel')

  confirm: =>
    @obligee.position = @$el.find('.position-input').val().trim()
    @obligee.person.name = @$el.find('.name-input').val().trim()
    @obligee.person.surname = @$el.find('.surname-input').val().trim()
    @obligee.person.email = @$el.find('.email-input').val().trim()
    @obligee.person.id_type = @$el.find('.id-type-select').val().trim()
    @obligee.person.person_id = parseInt(@$el.find('.person-id-input').val().trim())
    @obligee.skipValidation = false
    validation = @validate()
    if validation.isValid
      @trigger('done', @obligee)
    else 
      @render()

  validate: =>
    validation = {
      positionValid: @obligee.position.length > 0  
      nameValid: @obligee.person.name.length > 0
      surnameValid: @obligee.person.surname.length > 0
      emailValid: /[\w+\-.]+@[a-z\d\-.]+\.[a-z]+/i.test(@obligee.person.email)
      personIdValid: !!parseInt(@obligee.person.person_id) and parseInt(@obligee.person.person_id) > 0
    }
    validation.isValid = validation.positionValid and validation.nameValid and 
      validation.surnameValid and validation.emailValid and validation.personIdValid
    validation
