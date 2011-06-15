class App.Views.TweetsGraph extends Backbone.View

  tagName:   'section'
  className: 'tweet-graph'

  initialize: ->
    @dataTable = new google.visualization.DataTable()
    @dataTable.addColumn 'date', 'Date'
    @dataTable.addColumn 'number', 'Tweets'
    @chart = new google.visualization.ColumnChart(@el)

    @options.parent.bind 'change', @drawChart
    @collection.bind 'add', @tweetAdded
    @collection.bind 'refresh', @render

  drawChart: =>
    if @dataTable.getNumberOfRows() > 0
      data = google.visualization.data.group(@dataTable, [0], [column: 1, aggregation: google.visualization.data.sum, type: 'number'])
      @chart.draw data,
        width:  550
        height: 220
        titlePosition: 'none'
        legend: 'none'
        backgroundColor:
          fill:'#4b421b'
        gridlineColor:'#fff'
        colors: ['#fff']
        fontName:'helvetica'
        chartArea:
          top: 30
          left: 50
          width: 470
          height: 140
        vAxis:
          title: 'Tweets per Day'
          textStyle: {'color':'#fff'}
          titleTextStyle: {'color':'#fff'}
        hAxis:
          slantedText: false
          textStyle: {'color':'#fff'}

  render: =>
    @dataTable.removeRows 0, @dataTable.getNumberOfRows()
    @collection.each (tweet) -> @tweetAdded(tweet)
    @drawChart()
    @

  tweetAdded: (newTweet) =>
    @dataTable.addRow [newTweet.getDate(), 1]
