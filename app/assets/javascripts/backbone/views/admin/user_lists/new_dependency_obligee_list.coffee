#= require ./obligee_list
class audiencias.views.NewDependencyObligeeList extends audiencias.views.ObligeeList

  confirmNewObligee: (obligee) =>
    @dependency.set('obligee', obligee)
    @hideForm()

  showEditUserForm: =>
    @showingForm = true
    @render()