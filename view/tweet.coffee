class App.Views.Tweet extends Backbone.View

  tagName: 'li'
  className: 'tweet'

  initialize: ->
    @model.bind 'change:visible', @updateVisibility

  render: =>
    $(@el).html JST.tweet model: @model
    @updateVisibility()
    @

  updateVisibility: =>
    if @model.get('visible') then $(@el).show() else $(@el).hide()
