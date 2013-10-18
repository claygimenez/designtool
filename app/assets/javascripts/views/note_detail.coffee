class @Designtool.Views.NoteDetail extends Backbone.View
  className: 'note'

  render: ->
    @$el.template 'notes/show'
    @$el.find('.text').text(@model.text())
    @
