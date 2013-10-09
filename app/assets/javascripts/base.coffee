@Designtool =
  Models: {}
  Views: {}
  Collections: {}
  Routers: {}
  init: ->
    Designtool.router = new Designtool.Routers.ProjectsRouter()
  bootstrap: (key) ->
    json = document.createElement('div')
    json.innerHTML = $('#bootstrap').text()
    $.parseJSON(json.innerHTML)[key]

$(document).ready ->
  Designtool.init()
