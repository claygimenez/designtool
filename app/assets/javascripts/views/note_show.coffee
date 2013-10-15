class @Designtool.Views.NoteShow extends Backbone.View
  className: 'note'

  events: ->
    'mouseenter': 'enableHover'
    'mouseleave': 'disableHover'

  render: ->
    @$el.template 'notes/show'
    @$el.find('.text').text(@model.text)
    @

  enableHover: =>
    @$el.addClass('active')

  disableHover: =>
    @$el.removeClass('active')
