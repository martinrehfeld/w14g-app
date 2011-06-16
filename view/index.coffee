class App.Views.Index extends Backbone.View

  events:
    'submit form': 'update'

  update: (event) =>
    event.preventDefault()
    window.location.hash = '!/' + @$('[name=screen_name]').val()

  render: =>
    $(@el).html JST.report_form model: @model
    $('#form').empty().append(@el).addClass('loaded')
    $(@el).find('input').first().focus()
    @
