class App.Models.Cloud extends Backbone.Model

  initialize: ->
    @clear silent: true
    @get('collection').bind 'add', @tweetAdded

  clear: (options) ->
    @set frequencyMap: {}, options

  tweetAdded: (newTweet) =>
    frequencyMap = @get 'frequencyMap'

    for word in newTweet.analysedWords() when word != ''
      frequencyMap[word] = if frequencyMap[word]? then frequencyMap[word] + 1 else 1

  setFilter: (filter) ->
    @set filter: filter

  entries: ->
    filterRegex = new RegExp "^#{@get('filter') ? ''}"
    result      = {}

    for entry, frequency of @get('frequencyMap') when filterRegex.test entry
      result[entry] = frequency

    result

  topEntries: (count) ->
    entries                   = @entries()
    lowestAcceptableFrequency = _.last _.first _.sortBy(_.values(entries), (frequency) -> -frequency), count
    result                    = {}

    for entry, frequency of entries when frequency >= lowestAcceptableFrequency
      break if count < 1
      result[entry] = frequency
      count -= 1

    result
