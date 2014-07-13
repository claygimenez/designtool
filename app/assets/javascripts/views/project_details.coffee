class @Designtool.Views.ProjectDetail extends Support.CompositeView
  initialize: ->
    @model.on 'newnote', @render, this

  events: ->
    'submit form': 'addNote'

  render: ->
    @$el.template 'projects/detail'
    @$el.find('.title').text(@model.title())
    @$el.find('.reflections').text(@model.reflections())

    new Designtool.Views.BasicBar(model: @model).render()

    # obli_chart = new ObligationDebtChartView(
    #   el: "#testchart"
    #   collection: new Backbone.Collection(bonds)
    #   y_key: "debt_per_capita"
    #   y_scale_max: "7e3"
    #   base_height: 425
    #  breakpoints:
    #     600: 0.75
    #     380: 0.5
    # ).render()
    # $("body").append('<button id="update">Update</button>')
    # $('#update').click(=>
    #   console.log this
    #   graph1.transition()
    # )
    # graph1 = new @streamgraph()
    for note in @model.notes()
      do (note) =>
        view = new Designtool.Views.NoteShow(model: note)
        @appendChildTo view, $('.notearea')
        @

  addNote: =>
    console.log 'submitted'
    text = $('input#text').val()
    console.log @model.projectId()
    note = new Designtool.Models.Note({ text: text, project_id: @model.projectId() }).save {},
      success: () =>
        @model.trigger('newnote')
      error: () ->
        console.log 'nope'
    return false

  streamgraph: ->
  # number of layers
  # number of samples per layer
    transition = ->
      d3.selectAll("path").data(->
        d = layers1
        layers1 = layers0
        console.log "transition"
        layers0 = d
      ).transition().duration(2500).attr "d", area

# Inspired by Lee Byron's test data generator.
    bumpLayer = (n) ->
      bump = (a) ->
        x = 1 / (.1 + Math.random())
        y = 2 * Math.random() - .5
        z = 10 / (.1 + Math.random())
        i = 0

        while i < n
          w = (i / n - y) * z
          a[i] += x * Math.exp(-w * w)
          i++
        return
      a = []
      i = undefined
      i = 0
      while i < n
        a[i] = 0
        ++i
      i = 0
      while i < 5
        bump a
        ++i
      a.map (d, i) ->
        x: i
        y: Math.max(0, d)

    n = 20
    m = 200
    stack = d3.layout.stack().offset("wiggle")
    layers0 = stack(d3.range(n).map(->
      bumpLayer m
    ))
    layers1 = stack(d3.range(n).map(->
      bumpLayer m
    ))
    width = 960
    height = 500
    x = d3.scale.linear().domain([
      0
      m - 1
    ]).range([
      0
      width
    ])
    y = d3.scale.linear().domain([
      0
      d3.max(layers0.concat(layers1), (layer) ->
        d3.max layer, (d) ->
          d.y0 + d.y

      )
    ]).range([
      height
      0
    ])
    color = d3.scale.linear().range([
      "#aad"
      "#556"
    ])
    area = d3.svg.area().x((d) ->
      x d.x
    ).y0((d) ->
      y d.y0
    ).y1((d) ->
      y d.y0 + d.y
    )
    svg = d3.select("body").append("svg").attr("width", width).attr("height", height)
    svg.selectAll("path").data(layers0).enter().append("path").attr("d", area).style "fill", ->
      color Math.random()
