StreamgraphChartView = ChartView.extend(

  constructor: (options) ->
    ChartView.apply this, arguments_
    @$chart_container.attr "id", "streamgraph-chart-container"
    this

  draw: ->
    @initialize_data()
    @get_scales()
    @create_axes()
    @create_svg()
    @draw_bars()
    @bind_mouse_events()
    this

  transition = ->
    d3.selectAll("path").data(->
      d = layers1
      layers1 = layers0
      layers0 = d
    ).transition().duration(2500).attr "d", area

  bumpLayer = (n) ->
    bump = (a) ->
      x = 1 / (.1 + Math.random())
      y = 2 * Math.random() - .5
      z = 10 / (.1 + Math.random())
      i = 0

      while i < n
        w = (i / n-y) * z
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
    a.map(d, i) ->
      x: i
      y: Math.max(0, d)

  initialize_data = ->
    n = 20
    m = 200
    stack = d3.layout.stack().offset("wiggle")
    layers0 = stack(d3.range(n).map(->
      bumpLayer(m)
    ))
    layers1 = stack(d3.range(n).map(->
      bumpLayer(m)
    ))
    width = 960
    height = 500


