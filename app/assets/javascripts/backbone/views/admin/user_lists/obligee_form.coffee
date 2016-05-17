class audiencias.views.ObligeeForm extends Backbone.View
  template: JST["backbone/templates/admin/menu/obligee_form"]
  className: 'user-form'
  events:
    'click .cancel-user': 'cancel'
    'click .confirm-user': 'confirm'

  initialize: (options={}) ->
    @dependency = options.dependency
    @newObligee = options.newObligee

  render: ->
    @$el.html(@template(
      dependency: @dependency
      newObligee: @newObligee
    ))

  cancel: =>
    @trigger('cancel')

  confirm: =>
    @user.set(
      id_type: @$el.find('.id-type-select').val().trim(),
      person_id: parseInt(@$el.find('.person-id-input').val().trim()),
      name: @$el.find('.name-input').val().trim(),
      surname: @$el.find('.surname-input').val().trim()
      email: @$el.find('.email-input').val().trim()
    )
    if @user.isValid()
      @trigger('done', @user)
    else 
      validations = @user.validate()
      for attrName of validations 
        @$el.find(".#{attrName}-input").toggleClass('invalid', !validations[attrName])
