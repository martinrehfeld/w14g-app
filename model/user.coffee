class App.Models.User extends Backbone.Model

  initialize: ->
    @bind 'change:screenName', @fetchDetails

  fetchDetails: =>
    url = "http://api.twitter.com/1/users/show.json?callback=?&include_entities=1&screen_name=#{encodeURIComponent(@get 'screenName')}"
    $.getJSON url, (data) => @set data
