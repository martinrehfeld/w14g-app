class App.Views.Show extends Backbone.View

  initialize: ->
    tweets    = @model.get 'tweets'
    wordCloud = @model.get 'wordCloud'

    @userView          = new App.Views.User(model: @model.get('user'))
    @wordCloudView     = new App.Views.WordCloud(parent: @model, model: wordCloud)
    @tweetsFilterView  = new App.Views.TweetsFilter(parent: @model, collection: tweets)
    @tweetsView        = new App.Views.Tweets(parent: @model, collection: tweets)

  render: =>
    tweets = $('<section class="tweets" />').append @tweetsFilterView.el, @tweetsView.el
    $('#app #report').empty().append @userView.el, @wordCloudView.el, tweets
    @
