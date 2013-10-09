class @Designtool.Models.Project extends Backbone.Model
  urlRoot: '/projects'

  title: ->
    @get('title')

  domId: ->
    @get('dom_id')
