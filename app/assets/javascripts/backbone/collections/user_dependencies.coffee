class audiencias.collections.UserDependencies extends Backbone.Collection
  model: audiencias.models.Dependency
  idAttribute: 'id'

  expandParents: (dependency) ->
    if dependency.get('parent_id')
      parent = @get(dependency.get('parent_id'))
      if parent
        parent.set('expanded', true)
        @expandParents(parent)

  setSelected: (dependencyId) ->
    @deselectAll()
    newSelectedDependency = @get(dependencyId)
    newSelectedDependency.set('selected', true)
    newSelectedDependency.toggleExpanded()
    @expandParents(newSelectedDependency)

  deselectAll: ->
    @filter((d) -> d.get('selected')).forEach((d) -> d.set('selected', false))

  forceUpdate: (newDependency) ->
    savedDependency = @get(newDependency.id)
    if savedDependency
      savedDependency.set(newDependency)
      savedDependency.set('users', newDependency.users)
      savedDependency.set('obligee', newDependency.obligee)
      savedDependency.saveState()
    else 
      @add(newDependency)