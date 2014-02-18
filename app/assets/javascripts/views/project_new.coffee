class Designtool.Views.ProjectNew extends Backbone.View
  events: ->
    'click .actions': 'submit'

  render: ->
    @$el.template 'projects/new'
    @

  submit: ->
    value = $('#project_title').val()
    new Designtool.Models.Project({ title: value }).save {},
      success: ->
        window.location.href = "/projects"
