class @Designtool.Views.BasicBar extends Support.CompositeView
  render: ->
    console.log @model

    margin =
      top: 20
      right: 20
      bottom: 30
      left: 40

    width = 960 - margin.left - margin.right
    height = 500 - margin.top - margin.bottom
    x = d3.scale.ordinal().rangeRoundBands([
      0
      width
    ], .1)
    y = d3.scale.linear().range([
      height
      0
    ])

    xAxis = d3.svg.axis().scale(x).orient("bottom")
    yAxis = d3.svg.axis().scale(y).orient("left")

    chart = d3.select(".chart").append("svg")
      .attr("width", width + margin.left + margin.right)
      .attr("height", height + margin.top + margin.bottom)
      .append("g")
      .attr("transform", "translate(" + margin.left + "," + margin.right + ")")

    data = @model.reflections()

    x.domain(data.map((d) -> d.word))
    y.domain([0, d3.max(data, (d) -> d.value)])

    chart.append("g").attr("class", "x axis")
      .attr("transform", "translate(0," + height + ")")
      .call(xAxis)

    chart.append("g").attr("class", "y axis")
      .call(yAxis)
      .append("text")
      .attr("transform", "rotate(-90)")
      .attr("y", 6)
      .attr("dy", ".71em")
      .style("text-anchor", "end")
      .text("Frequency")

    chart.selectAll(".bar")
      .data(data)
      .enter()
      .append("rect")
      .attr("class", "bar")
      .attr("x", (d) -> x(d.word))
      .attr("width", x.rangeBand())
      .attr("y", (d) -> y(d.value))
      .attr("height", (d) -> height-y(d.value))
