class App.Views.Tweets extends Backbone.View

  tagName:   'ul'
  className: 'tweets-collection'

  initialize: ->
    @collection.bind 'add', @tweetAdded
    @collection.bind 'refresh', @render

  render: =>
    $(@el).empty()
    @collection.each (tweet) -> @tweetAdded(tweet)
    @

  tweetAdded: (newTweet) =>
    $(@el).append new App.Views.Tweet(model: newTweet, id: newTweet.get('id_str')).render().el
