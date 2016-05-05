class Audiencias.Views.UserLogin extends Backbone.View
  template: JST["backbone/templates/user_login"]

  events:
    "submit #edit-post": "update"

  update: (e) ->
    
  render: ->
    @$el.html(@template())
   