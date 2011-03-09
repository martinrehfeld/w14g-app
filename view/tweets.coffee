class App.Views.Tweets extends Backbone.View

  className: 'tweets'

  initialize: ->
    @filter = new App.Views.TweetsFilter(parent: @options.parent, collection: @collection).render()
    @collection.bind 'add', @tweetAdded

  render: =>
    $(@el).empty().append(@filter.el, JST.tweets_collection model: @options.parent, collection: @collection)
    @

  tweetAdded: (newTweet) =>
    $(new App.Views.Tweet(model: newTweet, id: newTweet.get('id_str')).render().el).appendTo('.tweets-collection')
