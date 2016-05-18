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
    @saveState()

  saveState: =>
    @lastSavedAttributes =  jQuery.extend(true, {}, @attributes)

  restore: =>
    expanded = @get('expanded')
    selected = @get('selected')
    @set(@lastSavedAttributes)
    @set('expanded', expanded)
    @set('selected', selected)
    
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
    hasAnyChild = audiencias.globals.userDependencies.findWhere({parent_id: @get('id')})
    if hasAnyChild
      @set('expanded', !@get('expanded'))

  expand: ->
    hasAnyChild = audiencias.globals.userDependencies.findWhere({parent_id: @get('id')})
    if hasAnyChild
      @set('expanded', true)

  collapse: ->
    @set('expanded', false)

  validateName: (name) ->
    name = @get('name')
    name.trim().length > 0