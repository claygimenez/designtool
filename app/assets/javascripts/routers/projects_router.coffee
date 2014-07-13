class @Designtool.Routers.ProjectsRouter extends Backbone.Router
  routes:
    'projects/new'                     : 'newProject'
    'projects/:project_id'             : 'showProject'


  initialize: ->
    Backbone.history.start(root: '/', pushState: true)


  newProject: =>
    project = new Designtool.Views.ProjectNew({ el: $('.projects') })
    project.render()


  showProject: (project_id) =>
    projectModel = new Designtool.Models.Project(id: project_id)
    projectModel.fetch
      success: ->
        new Designtool.Views.ProjectDetail({ model: projectModel, el: $('.projects') }).render()
