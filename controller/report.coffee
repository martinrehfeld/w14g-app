class App.Controllers.Report extends Backbone.Controller

  routes:
    ''                    : 'index'
    '!/:screenName'       : 'show'
    '!/:screenName/:word' : 'filter'

  initialize: ->
    @model    = new App.Models.Report
    @showView = new App.Views.Show(model: @model).render()

  index: ->
    new App.Views.Index(model: @model).render()
    $('#app #form').addClass('active').removeClass('inactive')
    $('#app #report').addClass('inactive').removeClass('active')

  show: (screenName) ->
    @model.set screenName: screenName
    @model.resetFilter()
    $('#app #form').addClass('inactive').removeClass('active')
    $('#app #report').addClass('active').removeClass('inactive')

  filter: (screenName, word) ->
    @model.set screenName: screenName
    @model.filterByWord decodeURIComponent(word)
    $('#app #form').addClass('inactive').removeClass('active')
    $('#app #report').addClass('active').removeClass('inactive')
