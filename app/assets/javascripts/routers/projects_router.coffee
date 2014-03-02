class @Designtool.Routers.ProjectsRouter extends Backbone.Router
  routes:
    'projects'                         : 'indexProjects'
    'projects/new'                     : 'newProject'
    'projects/:project_id'             : 'showProject'
    'projects/:project_id/notes/:id'   : 'showNote'

  initialize: ->
    projectsData = Designtool.bootstrap('projects')
    @projectsCollection = new Designtool.Collections.Projects(projectsData)
    Backbone.history.start(root: '/', pushState: true)

  indexProjects: =>
    new Designtool.Views.ProjectsShow({ collection: @projectsCollection, el: $('.projects') }).render()

  newProject: =>
    console.log 'new'
    project = new Designtool.Views.ProjectNew({ el: $('.projects') })
    project.render()

  showProject: (project_id) =>
    console.log 'show'
    @projectModel = @projectsCollection.find (project) -> project.get('dom_id') == 'project_' + project_id
    project = new Designtool.Views.ProjectDetail({ model: @projectModel, el: $('.projects') })
    project.render()

  showNote: (project_id, id) =>
    projectModel = @projectsCollection.find (project) -> project.get('dom_id') == 'project_' + project_id
    notesCollection = new Designtool.Collections.Notes(projectModel.notes())
    @noteModel = notesCollection.findWhere({ id: parseInt(id, 10) })
    note = new Designtool.Views.NoteDetail({ model: @noteModel, el: $('.projects') })
    note.render()
