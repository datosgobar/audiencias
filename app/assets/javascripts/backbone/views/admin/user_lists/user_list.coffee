class audiencias.views.UserList extends Backbone.View
  template: JST["backbone/templates/admin/user_list"]
  userTemplate: JST["backbone/templates/admin/user"]
  className: 'user-list'

  render: ->
    @$el.html(@template({
      title: @title  
    }))
