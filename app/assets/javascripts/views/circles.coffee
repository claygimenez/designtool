class @Designtool.Views.Circles extends Support.CompositeView
  render: -> 
    root = @model.clusters()

    diameter = 960
    format = d3.format(",d")

    pack = d3.layout.pack()
      .size([
        diameter - 4
        diameter - 4
      ]).value((d) ->
        d.value
      )

    svg = d3.select(".circles").append("svg")
      .attr("width", diameter)
      .attr("height", diameter)
      .append("g")
      .attr("transform", "translate(2,2)")

    node = svg.datum(root).selectAll(".node")
      .data(pack.nodes)
      .enter()
      .append("g")
      .attr("class", (d) -> (if d.children then "node" else "leaf node"))
      .attr("transform", (d) ->
        "translate(" + d.x + "," + d.y + ")"
      )

    node.append("title").text( (d) ->
      d.name + ((if d.children then "" else ": " + format(d.size)))
    )

    node.append("circle").attr("r", (d) ->
      d.r
    )

    node.filter((d) ->
      not d.children
    ).append("text")
      .attr("dy", ".3em")
      .style("text-anchor", "middle")
      .text( (d) ->
        d.name.substring 0, d.r / 3
      )

    d3.select(self.frameElement).style("height", diameter + "px")
