class App.Models.Report extends Backbone.Model

  initialize: ->
    tweets = new App.Collections.Tweets
    @set
      tweets:    tweets
      wordCloud: new App.Models.Cloud(collection: tweets)
    @bind 'change:screenName', @newScreenName

  newScreenName: =>
    tweets     = @get 'tweets'
    screenName = @get 'screenName'
    wordCloud  = @get 'wordCloud'

    tweets.clear()
    wordCloud.clear()
    @trigger 'change'
    tweets.fetch this

  filterByWord: (word) ->
    @get('tweets').filterByWord word

  resetFilter: ->
    @get('tweets').resetFilter()
