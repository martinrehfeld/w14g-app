class App.Views.Show extends Backbone.View

  initialize: ->
    tweets    = @model.get 'tweets'
    wordCloud = @model.get 'wordCloud'

    @userView          = new App.Views.User(model: @model.get('user'))
    @tweetsGraphView   = new App.Views.TweetsGraph(parent: @model, collection: tweets)
    @wordCloudView     = new App.Views.WordCloud(parent: @model, model: wordCloud)
    @tweetsFilterView  = new App.Views.TweetsFilter(parent: @model, collection: tweets)
    @tweetsView        = new App.Views.Tweets(parent: @model, collection: tweets)

  render: =>
    $(@el).html JST.report_form model: @model
    $('#form').empty().append @el
    tweets = $('<section class="tweets" />').append @tweetsFilterView.el, @tweetsView.el
    $('#profile').empty().append @userView.el
    $('#report').empty().append @tweetsGraphView.el, @wordCloudView.el, tweets
    @
