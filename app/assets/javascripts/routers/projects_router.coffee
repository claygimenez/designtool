class @Designtool.Routers.ProjectsRouter extends Backbone.Router
  routes:
    ''                        : 'indexProjects'
    ':project_id'             : 'showProject'
    ':project_id/notes/:id'   : 'showNote'

  initialize: ->
    projectsData = Designtool.bootstrap('projects')
    @projectsCollection = new Designtool.Collections.Projects(projectsData)
    Backbone.history.start(root: '/projects', pushState: true)

  indexProjects: =>
    projects = new Designtool.Views.ProjectsShow({ collection: @projectsCollection, el: $('.projects') })
    projects.render()

  showProject: (project_id) =>
    @projectModel = @projectsCollection.find (project) -> project.get('dom_id') == 'project_' + project_id
    project = new Designtool.Views.ProjectDetail({ model: @projectModel, el: $('.projects') })
    project.render()

  showNote: (project_id, id) =>
    projectModel = @projectsCollection.find (project) -> project.get('dom_id') == 'project_' + project_id
    notesCollection = new Designtool.Collections.Notes(projectModel.notes())
    @noteModel = notesCollection.findWhere({ id: parseInt(id, 10) })
    note = new Designtool.Views.NoteDetail({ model: @noteModel, el: $('.projects') })
    note.render()
