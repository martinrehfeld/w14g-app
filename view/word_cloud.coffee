class App.Views.WordCloud extends Backbone.View

  className: 'word-cloud'

  events:
    'click button': 'filterChange'

  initialize: ->
    @options.parent.bind 'change', @render

  filterChange: (event) =>
    event.preventDefault()
    @model.setFilter $(event.target).attr('data-filter')
    @render()

  render: =>
    $(@el)
      .html(JST.tweets_wordcloud model: @options.parent, collection: @model)
      .children('a').tagcloud()
    @
