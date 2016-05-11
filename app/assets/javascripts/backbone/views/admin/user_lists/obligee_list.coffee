#= require ./user_list
class audiencias.views.ObligeeList extends audiencias.views.UserList
  title: 'Sujeto obligado'
  positionInForm: true

  initialize: (dependency) ->
    @obligee = dependency.obligee
    @users = []