class audiencias.views.UserHelp extends Backbone.View
  template: JST["backbone/templates/users/user_help"]
  id: 'user-help'

  render: ->
    @$el.html(@template())