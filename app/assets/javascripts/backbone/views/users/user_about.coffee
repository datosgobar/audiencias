class audiencias.views.UserAbout extends Backbone.View
  template: JST["backbone/templates/users/user_about"]
  id: 'user-about'

  render: ->
    @$el.html(@template())