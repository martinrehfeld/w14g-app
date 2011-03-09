class App.Views.Index extends Backbone.View

  events:
    'click button': 'update'

  update: (event) =>
    event.preventDefault()
    window.location.hash = @$('[name=screen_name]').val()

  render: =>
    $(@el).html JST.report_form model: @model
    $('#app').empty().append(@el)
    $(@el).find('input').first().focus()
    @
