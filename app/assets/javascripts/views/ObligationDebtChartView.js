var ObligationDebtChartView = ChartView.extend({

  constructor: function(options) {
    ChartView.apply(this, arguments);
    this.create_tooltip();
    this.$chart_container.attr('id', 'debt-chart-container');
    return this;
  },

  draw: function() {
    this.get_scales();
    this.create_axes();
    this.create_svg();
    this.draw_bars();
    this.bind_mouse_events();
    return this;
  },

  format_big_currency: function(d) {
    var s = "$";
    if (d > 999999999) {
      s += Number(this.formatNumber(d/1e9)).toFixed(2) + " billion";
    } else if (d > 999999) {
      s += Number(this.formatNumber(d/1e6)).toFixed(1) + " million";
    } else {
      s += this.formatCommas(d);
    }
    return s;
  },

  create_tooltip: function() {
    var chart = this;

    chart.tooltip = d3.select("body")
      .append("div")
        .attr("id", "tooltip")
        .style("position", "absolute")
        .style("z-index", "10")
        .style("visibility", "hidden");

    //create a paragraph in the tooltip div for text
    d3.select("#tooltip")
      .append("p")
      .attr("class", "bold")
      .text("Year");

    //create a paragraph in the tooltip div for text
    d3.select("#tooltip")
      .append("p")
      .attr("class", "value")
      .text("Element value");
  },

  get_scales: function() {
    var chart = this;

    chart.yScale = d3.scale.linear()
      .range([chart.dimensions.height, 0]);

    chart.xScale = d3.scale.ordinal()
      .rangeBands([0, chart.dimensions.width], 0.4, 0.01);

    var yMax = d3.max(chart.data, function(d) { return d[chart.options.y_key]; });

    //set x and y scale values to map to the svg size
    chart.xScale.domain(_.map(chart.data, function(d) { return d.yr; }));
    chart.yScale.domain([0, chart.options.y_scale_max]);
  },

  create_axes: function() {
    var chart = this;

    chart.xAxis = d3.svg.axis()
      .scale(chart.xScale)
      .tickFormat(function(d) {
        if ( d > 1990 && d !== 1995 && d !== 2000 && d !== 2005 && d !== 2010 )
          return chart.formatNumber(d).replace(/^(19|20)/g, "'");
        return chart.formatNumber(d);
      })
      .orient("bottom");

    if ($(chart.el).width() <= 550)
      chart.xAxis.tickValues([1995, 2000, 2005, 2010]);

    chart.yAxis = d3.svg.axis()
      .scale(chart.yScale)
      .tickSize(chart.dimensions.wrapperWidth)
      .ticks(( $(chart.el).width() <= 550 )? 5:9 )
      .orient("right");

    chart.yAxis.tickFormat(function(d) {
      return "$" + chart.formatCommas(d);
    });
  },

  create_svg: function() {
    var chart = this;

    //create new svg for the bar chart
    chart.svg = d3.select(chart.el).append("svg")
      .attr("width", chart.dimensions.wrapperWidth)
      .attr("height", chart.dimensions.wrapperHeight)
      .attr("class", "chart")
    .append("g")
      .attr("transform", "translate(" + chart.options.margin.left + ", 20)");

    //create and set x axis position
    chart.svg.append("g")
      .attr("class", "x axis")
      .attr("transform", "translate(0," + chart.dimensions.height + ")")
      .attr("text-anchor", "middle")
      .call(chart.xAxis);

    //create and set y axis positions
    var gy = chart.svg.append("g")
      .attr("class", "y axis")
      .attr("transform", "translate(-50, 0)")
      .attr("y", 6)
      .call(chart.yAxis);

    gy.selectAll("g")
      .filter(function(d) { return d; })
      .classed("minor", true);

    gy.selectAll("text")
      .attr("x", 4)
      .attr("dy", -4);
  },

  draw_bars: function() {
    var chart = this;

    chart.svg.selectAll("rect")
      .data(chart.data)
        .enter()
        .append("rect")
          .attr("class", "bar")
          .attr("text-anchor", "middle")
          .attr("x", function(d) {
            return chart.xScale(d.yr);
          })
          .attr("y", function(d) {
            return chart.yScale(d[chart.options.y_key]);
          })
          .attr("width", chart.xScale.rangeBand())
          .attr("height", function(d) {
            return chart.dimensions.height - chart.yScale(d[chart.options.y_key]) - 1;
          });
  },

  bind_mouse_events: function() {
    var chart = this;

    chart.svg.selectAll("rect")
      .on("mouseover", function(d) {

        //update tool tip text
        d3.select("#tooltip")
          .select(".bold")
          .text(d.yr);

        d3.select(".value")
          .text(chart.format_big_currency(d[chart.options.y_key]));

        return chart.tooltip.style("visibility", "visible");
      })
      .on("mousemove", function() {
        var svg_width = d3.select(chart.el)[0][0].clientWidth;
        var tip_width = $(chart.tooltip[0][0]).width();

        //set position of the tooltip based on mouse position
        if (d3.event.offsetX > ((svg_width - tip_width - 20))) {
          return chart.tooltip
            .style("top", (d3.event.pageY-10)+"px")
            .style("left",(d3.event.pageX-(tip_width+32))+"px");
        } else {
          return chart.tooltip
            .style("top", (d3.event.pageY-10)+"px")
            .style("left",(d3.event.pageX+10)+"px");
        }
      })
      .on("mouseout", function(){
        return chart.tooltip.style("visibility", "hidden");
      });
  }

});
