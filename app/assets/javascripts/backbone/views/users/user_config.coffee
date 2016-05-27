class audiencias.views.UserConfig extends Backbone.View
  template: JST["backbone/templates/users/user_config"]
  id: 'user-config'

  initialize: ->
    audiencias.globals.users.on('change add', @render)

  render: =>
    @$el.html(@template())