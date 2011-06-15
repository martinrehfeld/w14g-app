class App.Views.WordCloud extends Backbone.View

  tagName:   'section'
  className: 'word-cloud'

  events:
    'click a': 'filterChange'

  initialize: ->
    @options.parent.bind 'change', @render

  filterChange: (event) =>
    event.preventDefault()
    @model.setFilter $(event.target).data('filter')
    @render()

  render: =>
    $(@el)
      .html(JST.tweets_wordcloud model: @options.parent, collection: @model)
      .children('a').tagcloud()
    @
