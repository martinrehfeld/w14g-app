class App.Controllers.Report extends Backbone.Controller

  routes:
    "": "index"
    ":screenName": "show"
    ":screenName/:word": "filter"

  initialize: ->
    @model = new App.Models.Report
    @showView = new App.Views.Show model: @model

  index: ->
    new App.Views.Index(model: @model).render()

  show: (screenName) ->
    @model.set screenName: screenName
    @model.resetFilter()
    @showView.render()

  filter: (screenName, word) ->
    @model.set screenName: screenName
    @model.filterByWord decodeURIComponent word
    @showView.render()
