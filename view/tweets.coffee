class App.Views.Tweets extends Backbone.View

  tagName:   'ul'
  className: 'tweets-collection'

  initialize: ->
    @collection.bind 'add', @tweetAdded

  render: =>
    # $(@el).empty().append(JST.tweets_collection model: @options.parent, collection: @collection)
    @

  tweetAdded: (newTweet) =>
    $(@el).append new App.Views.Tweet(model: newTweet, id: newTweet.get('id_str')).render().el
