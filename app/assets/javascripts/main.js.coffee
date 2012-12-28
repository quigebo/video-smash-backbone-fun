$ ->
  genreView = new VideoSmash.Views.GenreSelect
  videos = new VideoSmash.Collections.Videos
  player = new VideoSmash.Views.VideoPlayer
    genre:
      id: genreView.el.value
      title: $(genreView.el).find("option[value=\"#{genreView.el.value}\"]").text()
    collection: videos
