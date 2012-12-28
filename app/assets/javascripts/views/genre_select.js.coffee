VideoSmash.Views.GenreSelect = Backbone.View.extend
  el: 'select#genre-select'

  initialize: ->
    @setInitialGenre()
    @fetchVideos()

  setInitialGenre: ->
    last_viewed = @$el.attr 'data-last_viewed'
    @$el.val(last_viewed) if last_viewed

  events:
    "change": "fetchVideos"

  fetchVideos: ->
    genre_id = @el.value
    genre_title = @$el.find("option[value=\"#{genre_id}\"]").text()
    VideoSmash.trigger 'genre:change', id: genre_id, title: genre_title
