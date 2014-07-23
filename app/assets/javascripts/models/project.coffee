class @Designtool.Models.Project extends Backbone.Model
  urlRoot: '/projects'

  title: ->
    @get('title')

  notes: ->
    @get('notes')

  reflections: ->
    @get('reflections')

  words: ->
    Object.keys(@reflections())

  tfidf: ->
    @get('tfidf')

  clusters: ->
    @get('clusters')

  projectId: ->
    @get('id')

  # domId: ->
    # @get('dom_id')
