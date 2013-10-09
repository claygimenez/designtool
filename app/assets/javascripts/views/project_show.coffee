class @Designtool.Views.ProjectShow extends Backbone.View
  className: 'project'

  events: ->
    'mouseenter': 'enableHover'
    'mouseleave': 'disableHover'

  render: ->
    @$el.template 'projects/show'
    @$el.find('.title').text(@model.title())
    @

  enableHover: =>
    @$el.addClass('active')

  disableHover: =>
    @$el.removeClass('active')
