class @Designtool.Models.Project extends Backbone.Model
  urlRoot: '/projects'

  title: ->
    @get('title')

  notes: ->
    @get('notes')

  projectId: ->
    @get('id')

  domId: ->
    @get('dom_id')
