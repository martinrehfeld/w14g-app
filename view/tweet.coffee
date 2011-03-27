class App.Views.Tweet extends Backbone.View

  tagName: 'li'
  className: 'tweet'

  initialize: ->
    @model.bind 'change:visible', @updateVisibility

  render: =>
    $(@el).html JST.tweet model: @model
    $(@el).addClass('conversation') if @model.isConversation()
    @updateVisibility()
    @

  updateVisibility: =>
    if @model.get('visible') then $(@el).show() else $(@el).hide()
