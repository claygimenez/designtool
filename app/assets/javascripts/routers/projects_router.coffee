class @Designtool.Routers.ProjectsRouter extends Backbone.Router
  routes:
    ''  : 'indexProjects'

  initialize: ->
    projectsData = Designtool.bootstrap('projects')
    @projectsCollection = new Designtool.Collections.Projects(projectsData)
    Backbone.history.start(root: '/projects', pushState: true)

  indexProjects: =>
    projects = new Designtool.Views.ProjectsShow({ collection: @projectsCollection, el: $('.projects') })
    projects.render()
