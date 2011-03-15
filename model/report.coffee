class App.Models.Report extends Backbone.Model

  initialize: ->
    tweets = new App.Collections.Tweets
    @set
      user:      new App.Models.User
      tweets:    tweets
      wordCloud: new App.Models.Cloud(collection: tweets)
    @bind 'change:screenName', @newScreenName

  newScreenName: =>
    user       = @get 'user'
    tweets     = @get 'tweets'
    screenName = @get 'screenName'
    wordCloud  = @get 'wordCloud'

    tweets.clear()
    wordCloud.clear()
    user.set screenName: screenName
    @trigger 'change'
    tweets.fetch this

  filterByWord: (word) ->
    @get('tweets').filterByWord word

  resetFilter: ->
    @get('tweets').resetFilter()
