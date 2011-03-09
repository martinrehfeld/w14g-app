class App.Controllers.Report extends Backbone.Controller

  routes:
    "": "index"
    ":screen_name": "show"
    ":screen_name/:word": "filter"

  initialize: ->
    @model = new App.Models.Report
    @showView = new App.Views.Show model: @model

  index: ->
    new App.Views.Index(model: @model).render()

  show: (screen_name) ->
    @model.set screen_name: screen_name
    @model.resetFilter()
    @showView.render()

  filter: (screen_name, word) ->
    @model.set screen_name: screen_name
    @model.filterByWord decodeURIComponent word
    @showView.render()
