class @Designtool.Views.ProjectDetail extends Support.CompositeView
  initialize: ->
    @model.on 'newnote', @render, this

  events: ->
    'submit form': 'addNote'

  render: ->
    console.log 'render'
    @$el.template 'projects/detail'
    @$el.find('.title').text(@model.title())
    for note in @model.notes()
      do (note) =>
        view = new Designtool.Views.NoteShow(model: note)
        @appendChild view
        @

  addNote: =>
    console.log 'submitted'
    text = $('input#text').val()
    console.log @model.projectId()
    note = new Designtool.Models.Note({ text: text, project_id: @model.projectId() }).save {},
      success: () =>
        @model.trigger('newnote')
      error: () ->
        console.log 'nope'
    return false
