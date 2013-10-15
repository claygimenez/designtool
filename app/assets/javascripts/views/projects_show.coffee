class @Designtool.Views.ProjectsShow extends Support.CompositeView
  render: ->
    @collection.each (project) =>
      view = new Designtool.Views.ProjectShow(model: project)
      @appendChild view

      @
