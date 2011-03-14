class App.Controllers.Report extends Backbone.Controller

  routes:
    "": "index"
    ":screenName": "show"
    ":screenName/:word": "filter"

  initialize: ->
    @model = new App.Models.Report
    @showView = new App.Views.Show(model: @model).render()

  index: ->
    new App.Views.Index(model: @model).render()

  show: (screenName) ->
    @model.set screenName: screenName
    @model.resetFilter()

  filter: (screenName, word) ->
    @model.set screenName: screenName
    @model.filterByWord decodeURIComponent word
