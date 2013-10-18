class @Designtool.Views.ProjectDetail extends Support.CompositeView
  render: ->
    @$el.template 'projects/detail'
    @$el.find('.title').text(@model.title())
    for note in @model.notes()
      do (note) =>
        view = new Designtool.Views.NoteShow(model: note)
        @appendChild view
        @
