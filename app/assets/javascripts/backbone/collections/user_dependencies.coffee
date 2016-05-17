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
    @filter((d) -> d.get('selected')).forEach((d) -> d.set('selected', false))
    newSelectedDependency = @get(dependencyId)
    newSelectedDependency.set('selected', true)
    newSelectedDependency.toggleExpanded()
    @expandParents(newSelectedDependency)

  forceUpdate: (newDependency) ->
    savedDependency = @get(newDependency.id)
    if savedDependency
      savedDependency.set(newDependency)
      savedDependency.set('users', newDependency.users)
    else 
      @add(newDependency)