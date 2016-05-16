class audiencias.views.NewDependencyMenu extends Backbone.View
  id: 'new-dependency-menu'
  className: 'generic-menu modifying hidden'
  template: JST["backbone/templates/admin/menu/new_dependency_menu"]
  events: 
    'click #cancel': 'cancelNewDependency'
    'click #edit-title': 'editTitle'
    'click #confirm-edit-title': 'confirmTitle'

  render: ->
    @adminList = new audiencias.views.AdminList({})
    @obligeeList = new audiencias.views.ObligeeList({})
    @operatorList = new audiencias.views.OperatorList({obligee:{}})
    
    @$el.html(@template())
    
    @adminList.render()
    @obligeeList.render()
    @operatorList.render()
    
    @adminList.$el.removeClass('hidden')
    @$el.find('.menu-lists').html(@adminList.el)
      .append(@obligeeList.el)
      .append(@operatorList.el)

    @editTitle()

  cancelNewDependency: =>
    $(window).trigger('cancel-new-dependency')

  editTitle: =>
    @$el.find('.title-name, #edit-title').addClass('hidden')
    @$el.find('.title-form, #confirm-edit-title').removeClass('hidden')
    @$el.find('.title-input').focus()

  confirmTitle: =>
    @$el.find('.title-name, #edit-title').removeClass('hidden')
    @$el.find('.title-form, #confirm-edit-title').addClass('hidden')
    @$el.find('.title-name').text(@$el.find('.title-input').val())