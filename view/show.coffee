class App.Views.Show extends Backbone.View

  initialize: ->
    tweets    = @model.get 'tweets'
    wordCloud = @model.get 'wordCloud'

    @wordCloudView     = new App.Views.WordCloud parent: @model, model: wordCloud
    @tweetsFilterView  = new App.Views.TweetsFilter(parent: @model, collection: tweets).render()
    @tweetsView        = new App.Views.Tweets(parent: @model, collection: tweets).render()

  render: =>
    $('#app').empty().append(@wordCloudView.el, @tweetsFilterView.el, @tweetsView.el)
    @
