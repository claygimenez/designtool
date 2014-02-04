class Designtool.Views.ProjectNew extends Backbone.View
  events: ->
    'click .actions': 'submit'

  render: ->
    @$el.template 'projects/new'
    @

  submit: ->
    attributes = new FormAttributes(@$('form')).attributes()
    self = @
    project = new Designtool.Models.Project(attributes).save()
