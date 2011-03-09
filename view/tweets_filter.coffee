class App.Views.TweetsFilter extends Backbone.View

  className: 'tweets-filter'

  initialize: ->
    @collection.bind('filterchange', @render)

  render: =>
    $(@el).html(JST.tweets_filter model: @options.parent, collection: @collection)
    @
