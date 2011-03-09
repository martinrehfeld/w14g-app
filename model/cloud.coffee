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

  topEntries: (count) ->
    frequencyMap = @get 'frequencyMap'
    lowestAcceptableFrequency = _.last _.first _.sortBy(_.values(frequencyMap), (frequency) -> -frequency), count
    result = {}

    for entry, frequency of frequencyMap when frequency >= lowestAcceptableFrequency
      break if count <= 1
      result[entry] = frequency
      count -= 1

    result
