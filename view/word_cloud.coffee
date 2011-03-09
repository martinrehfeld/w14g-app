class App.Views.WordCloud extends Backbone.View

  className: 'word-cloud'

  initialize: ->
    @options.parent.bind 'change', @render

  render: =>
    $(@el)
      .html(JST.tweets_wordcloud model: @options.parent, collection: @model.topEntries(75))
      .children('a').tagcloud()
    @
