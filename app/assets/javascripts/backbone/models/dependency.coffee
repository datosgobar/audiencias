class audiencias.models.Dependency extends Backbone.Model

  defaults: {
    active: true,
    direct_sub_dependencies: [],
    expanded: false,
    name: 'Nueva dependencia'
    obligee: null,
    parent_id: null,
    selected: false,
    top: false,
    users: []
  }

  initialize: ->
    @lastSavedAttributes =  jQuery.extend(true, {}, @attributes)

  restore: =>
    @set(@lastSavedAttributes)

  validate: ->
    validations = {
      name: @validateName()
    }
    valid = validations.name
    if valid 
      undefined 
    else 
      validations

  toggleExpanded: ->
    if @get('direct_sub_dependencies').length > 0
      @set('expanded', !@get('expanded'))

  expand: ->
    if @get('direct_sub_dependencies').length > 0
      @set('expanded', true)

  collapse: ->
    @set('expanded', false)

  validateName: (name) ->
    name = @get('name')
    name.trim().length > 0