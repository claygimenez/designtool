class @Designtool.Views.ProjectShow extends Support.CompositeView
  className: 'project'

  events: ->
    'mouseenter': 'enableHover'
    'mouseleave': 'disableHover'

  render: ->
    @$el.template 'projects/show'
    @$el.find('.title').text(@model.title())
    for note in @model.notes()
      do (note) =>
        console.log('hello')
        view = new Designtool.Views.NoteShow(model: note)
        @appendChild view
        @

  enableHover: =>
    @$el.addClass('active')

  disableHover: =>
    @$el.removeClass('active')
