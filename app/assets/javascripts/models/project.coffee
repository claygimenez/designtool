class @Designtool.Models.Project extends Backbone.Model
  urlRoot: '/projects'

  title: ->
    @get('title')

  notes: ->
    @get('notes')

  domId: ->
    @get('dom_id')
