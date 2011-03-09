class App.Views.Show extends Backbone.View

  initialize: ->
    tweets    = @model.get 'tweets'
    wordCloud = @model.get 'wordCloud'

    @tweetsView    = new App.Views.Tweets(parent: @model, collection: tweets).render()
    @wordCloudView = new App.Views.WordCloud parent: @model, model: wordCloud

  render: =>
    $('#app').empty().append(@wordCloudView.el, @tweetsView.el)
    @
