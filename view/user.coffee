class App.Views.User extends Backbone.View

  tagName:   'section'
  className: 'user-profile'

  initialize: ->
    @model.bind 'change', @render

  render: =>
    if @model.get('id')?
      $(@el).html(JST.user_profile model: @model)
      $('#profile').addClass('loaded')
    @
