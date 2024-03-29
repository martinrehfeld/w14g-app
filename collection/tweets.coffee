class App.Collections.Tweets extends Backbone.Collection

  model: App.Models.Tweet

  comparator: (tweet) ->
    -(tweet.get 'id')

  initialize: ->
    @clear silent: true
    @bind 'add', @tweetAdded

  clear: (options) ->
    @wordMap = {}
    @resetFilter options
    @refresh [], options

  fetch: (report) ->
    page       = 1
    perPage    = 200
    maxPages   = 3200 / perPage
    screenName = report.get 'screenName'
    baseUrl    = 'http://api.twitter.com/1/statuses/user_timeline.json?screen_name=' +
                 encodeURIComponent(screenName) +
                 "&include_rts=1&include_entities=1&trim_user=1&callback=?&count=#{perPage}&page="

    # TODO: inform user about errors
    #       - 400 Bad Request will be returned when you are over the rate limit
    #       - 401 Unauthorized will be given when the feed is protected
    #       - 404 Not Found will be given when the screenname is unknown
    #       - 503 Service Temporarily Unavailable when Twitter is over capacity
    fetchNext = =>
      $.getJSON baseUrl + page, (data) =>
        if data.length > 0 && report.get('screenName') == screenName
          @add data
          report.trigger 'change'
          if page < maxPages && data.length == perPage
            page += 1
            setTimeout fetchNext, 0
    setTimeout fetchNext, 0

  tweetAdded: (newTweet) ->
    wordMap              = @wordMap
    currentFilter        = @currentFilter
    matchesCurrentFilter = false

    if !@isFiltered()
      matchesCurrentFilter = true

    for word in _.uniq newTweet.analysedWords() when word != ''
      # FF would have a function watch() here somehow; should look into it and find the root cause
      # checking the type for now
      if wordMap[word]? && typeof wordMap[word] != 'function'
        wordMap[word].push newTweet
      else
        wordMap[word] = [newTweet]

      if !matchesCurrentFilter && word == currentFilter
        matchesCurrentFilter = true

    newTweet.set visible: matchesCurrentFilter

  isFiltered: ->
    @currentFilter?

  resetFilter: (options) ->
    options ?= {}

    @currentFilter = null
    @each (tweet) -> tweet.set visible: true
    @trigger 'filterchange' if !options.silent

  filterByWord: (word) ->
    wordMap        = @wordMap
    wordMap[word]  = [] if !wordMap[word]
    @visibleModels = wordMap[word]
    @currentFilter = word

    @each (tweet) -> tweet.set visible: false
    for tweet in @visibleModels
      tweet.set visible: true
    @trigger 'filterchange'

  visible: ->
    if @isFiltered() then @visibleModels else @models
