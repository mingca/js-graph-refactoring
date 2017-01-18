class Graph
  constructor: (data) ->
    @graph    = d3.select('#graph')
    @width    = 1000
    @height   = 500
    @margins  =
      top:    20
      right:  20
      bottom: 20
      left:   50
    @createScales(data)
    @addAxes()

  createScales: (data) ->
    xMin = d3.min(data, (d) -> d.x)
    xMax = d3.max(data, (d) -> d.x)
    yMin = d3.min(data, (d) -> d.y)
    yMax = d3.max(data, (d) -> d.y)

    # -- X Scale
    @xRange = d3.scale.linear()
      .range([
        @margins.left               # Left  end of Graph
        @width - (@margins.right)   # Right end of Graph
      ])
      .domain([xMin, xMax])

    # -- Y Scale
    @yRange = d3.scale.linear()
      .range([
        @height - (@margins.top)    # Bottom end of Graph
        @margins.bottom             # Top    end of Graph
      ])
      .domain([yMin, yMax])

  addAxes: ->
    # -- X axis
    xAxis = d3.svg.axis()
      .scale        (@xRange)
      .tickSize     (5)
      .tickSubdivide(true)

    @graph.append('svg:g')
      .attr('class',      'x axis')
      .attr('transform',  'translate(0,' + (@height - @margins.bottom) + ')')   # 
      .call xAxis

    # -- Y axis
    yAxis = d3.svg.axis()
      .scale        (@yRange)
      .tickSize     (5)
      .orient       ('left')
      .tickSubdivide(true)

    @graph.append('svg:g')
      .attr('class',      'y axis')
      .attr('transform',  'translate(' + @margins.left + ',0)')
      .call yAxis
      
  lineGenerator: ->
    d3.svg.line()
      .x((d) =>
        @xRange d.x
      )
      .y((d) =>
        @yRange d.y
      )
      .interpolate('basis')

  render: ->
    @graph.append('svg:path')
      .attr('d',            @lineGenerator()(data))
      .attr('stroke',       'blue')
      .attr('stroke-width', 2)
      .attr 'fill',         'none'

window.Graph = Graph
