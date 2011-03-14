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
    page = 1
    screenName = report.get('screenName')
    baseUrl = 'http://api.twitter.com/1/statuses/user_timeline.json?screen_name=' +
              encodeURIComponent(screenName) +
              '&include_rts=1&include_entities=1&trim_user=1&callback=?&count=200&page='

    fetchNext = =>
      $.getJSON baseUrl + page, (data) =>
        if data.length > 0 && report.get('screenName') == screenName
          @add data
          report.trigger 'change'
          if page < 16 # count*page: max 3,200
            page += 1
            setTimeout fetchNext, 0
    setTimeout fetchNext, 0

  tweetAdded: (newTweet) ->
    wordMap = @wordMap
    currentFilter = @currentFilter
    matchesCurrentFilter = false

    if !@isFiltered()
      matchesCurrentFilter = true

    for word in _.uniq newTweet.analysedWords() when word != ''
      if wordMap[word]?
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
    @each (tweet) ->
      tweet.set visible: true

    if !options.silent
      @trigger 'filterchange'

  filterByWord: (word) ->
    wordMap = @wordMap
    if !wordMap[word]
      wordMap[word] = []
    @visibleModels = wordMap[word]
    @currentFilter = word

    @each (tweet) ->
      tweet.set visible: false

    for tweet in @visibleModels
      tweet.set visible: true

    @trigger 'filterchange'

  visible: ->
    if @isFiltered() then @visibleModels else @models
