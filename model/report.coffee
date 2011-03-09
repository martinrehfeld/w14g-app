class App.Models.Report extends Backbone.Model

  initialize: ->
    tweets = new App.Collections.Tweets
    @set
      tweets:    tweets
      wordCloud: new App.Models.Cloud(collection: tweets)
    @bind 'change:screen_name', @newScreenName

  newScreenName: =>
    screenName = @get 'screen_name'
    tweets     = @get 'tweets'
    wordCloud  = @get 'wordCloud'

    tweets.clear()
    wordCloud.clear()
    @trigger 'change'
    tweets.fetch(this)

  filterByWord: (word) ->
    @get('tweets').filterByWord word

  resetFilter: ->
    @get('tweets').resetFilter()
