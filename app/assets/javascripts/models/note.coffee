class @Designtool.Models.Note extends Backbone.Model
  urlRoot: '/notes'

  text: ->
    @get('text')
