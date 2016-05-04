class window.DependencyMenu extends window.AbstractMenu

  constructor: (@dependencies) ->
    @menuId = '#dependencies-menu'
    @listenEvents()

  listenEvents: ->
    $(window).on('dependency:selected', @selectDependency)
    $('#dependencies-tree .add-new-dependency').on('click', @newTopDependency)
    $('#admin-menu #add-dependency').on('click', @newTopDependency)
    $('#add-sub-dependency').on('click', @newSubDependency)
    $('#see-current-dependency-admin').on('click', @showAdmin)
    $('#hide-current-dependency-admin').on('click', @hideAdmin)
    $('#dependencies-menu .cancel-top-action .cancel').on('click', @showDefault)
    $('#submit-dependency-name').on('click', @submitNewDependencyName)
    $('#edit-dependency-name').on('click', @editNewDependencyName)
    $('#current-dependency-admin .inlist-form-actions .skip').on('click', @showNewObligeeForm)
    $('#current-dependency-obligee .inlist-form-actions .skip').on('click', @showNewOperatorForm)
    $('#current-dependency-operators .inlist-form-actions .skip').on('click', @showPreview)

  selectDependency: (e, dependencyId) =>
    dependency = _.find(@dependencies, (d) -> d.id == dependencyId ) 
    @currentDependency = dependency
    @showDefault()

  showDefault: =>
    $('#admin-menu').addClass('hidden')
    $('#dependencies-menu').removeClass('hidden')
    @showTopMenu()
    @hideAdmin()
    @showCurrentAdminButton()
    @showTitle()
    @hideNewForms()
    @hidePreview()

  newTopDependency: =>
    @newDependency = {
      parent_id: null
    }
    @showNewDependencyForm()

  newSubDependency: =>
    @newDependency = {
      parent_id: @currentDependency.id
    }
    @showNewDependencyForm()

  showNewDependencyForm: =>
    @showCurrentAdmin()
    @showCancelAction()
    @hideAllIcons()
    @hideAllUsers()
    @hideNewForms()
    $('#admin-menu').addClass('hidden')
    $('#dependencies-menu').removeClass('hidden')
    @showTitleInput()

  hideAllIcons: ->
    $('#dependencies-menu .user-section-title img').addClass('hidden')

  hideAllUsers: ->
    $('#dependecies-menu .user-section-list').addClass('hidden')

  showTitle: ->
    $('#dependencies-menu .title-form').addClass('hidden')
    $('#dependencies-menu .title-text').removeClass('hidden')
      .text(@currentDependency.name)
    $('#see-current-dependency-admin').removeClass('hidden')
      .siblings().addClass('hidden')

  showTitleInput: ->
    $('#dependencies-menu .title-form').removeClass('hidden')
    $('#new-dependency-name').prop('disabled', false)
    $('#dependencies-menu .title-text').addClass('hidden')
    $('#submit-dependency-name').removeClass('hidden')
      .siblings().addClass('hidden')

  showAdmin: =>
    @showCurrentAdmin()
    @hideCurrentAdminButton()

  hideAdmin: =>
    @hideCurrentAdmin()
    @showCurrentAdminButton()

  showCurrentAdmin: =>
    $('#current-dependency-admin').removeClass('hidden')

  hideCurrentAdmin: =>
    $('#current-dependency-admin').addClass('hidden')

  hideCurrentAdminButton: =>
    $('#see-current-dependency-admin').addClass('hidden')
    $('#hide-current-dependency-admin').removeClass('hidden')

  showCurrentAdminButton: =>
    $('#see-current-dependency-admin').removeClass('hidden')
    $('#hide-current-dependency-admin').addClass('hidden')

  submitNewDependencyName: =>
    @newDependency.name = $('#new-dependency-name').prop('disabled', true).val().trim()
    $('#edit-dependency-name').removeClass('hidden')
      .siblings().addClass('hidden')
    @showNewAdminForm()

  showNewAdminForm: =>
    @hideNewForms()
    $('#current-dependency-admin .inlist-form').removeClass('hidden')

  showNewObligeeForm: =>
    @hideNewForms()
    $('#current-dependency-obligee .inlist-form').removeClass('hidden')

  showNewOperatorForm: =>
    @hideNewForms()
    $('#current-dependency-operators .inlist-form').removeClass('hidden')

  editNewDependencyName: =>
    $('#new-dependency-name').prop('disabled', false)
    $('#submit-dependency-name').removeClass('hidden')
      .siblings().addClass('hidden')

  hideNewForms: ->
    $('#dependencies-menu .inlist-form').addClass('hidden')

  showPreview: =>
    @hideNewForms()
    $('#dependencies-menu #preview-actions').removeClass('hidden')

  hidePreview: =>
    $('#dependencies-menu #preview-actions').addClass('hidden')
