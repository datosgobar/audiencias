class audiencias.views.AdminLanding extends Backbone.View
  id: 'admin-landing'
  template: JST["backbone/templates/admin/admin_landing"]

  initialize: ->
    @navigation = new audiencias.views.DependenciesNavigation
    @dependenciesTree = new audiencias.views.DependenciesTree

  render: ->
    @$el.html(@template())

    @navigation.render()
    @dependenciesTree.render()

    @$el.find('#left-container').html(@navigation.el)
    @$el.find('#left-container').append(@dependenciesTree.el)
