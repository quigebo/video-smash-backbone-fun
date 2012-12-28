VideoSmash.Views.VideoPlayer = Backbone.View.extend
  OFFSET: 10

  el: 'section#player'

  initialize: (options) ->
    @genre = options.genre
    @_startVideoFetch()
    @previouslyViewed = new VideoSmash.Views.PreviouslyViewed({ collection: new VideoSmash.Collections.Viewings })
    VideoSmash.trigger 'load:previouslyViewed', @genre.id
    VideoSmash.on 'genre:change', @resetStage, @

  resetStage: (genre) ->
    @genre = genre
    @collection.reset []
    @previouslyViewed.collection.reset []
    VideoSmash.trigger 'load:previouslyViewed', @genre.id
    @_setCurrentVideoIndex(0)
    @_startVideoFetch()

  currentVideoIndex: 0
  currentlyFetching: false

  events:
    "click button#next-video": "playNextVideo"

  playNextVideo: ->
    @addVideoToPrevious(@currentVideo())
    @incrementVideoIndex()
    if @shouldFetchNextSet()
      @_startVideoFetch()
    @render()

  shouldFetchNextSet: ->
    if @currentlyFetching
      false
    else
      return @currentVideoIndex >= Math.floor(@collection.size() / 2)

  currentVideo: ->
    @collection.models[@currentVideoIndex].set genre: @genre.title

  incrementVideoIndex: ->
    newIndex = @currentVideoIndex + 1
    @_setCurrentVideoIndex(newIndex)

  recordViewing: ->
    $.ajax
      type: 'POST',
      url: '/viewings',
      data:
        video_id: @currentVideo().get('_id')
        genre_id: @genre.id
      error: (xhr, textStatus, error) ->
        # error handling here

  addVideoToPrevious: (video) ->
    video.set({ created_at: @currentFormattedDate() })
    @previouslyViewed.collection.add video

  currentFormattedDate: ->
    date       = new Date()
    month      = date.getMonth() + 1
    day        = date.getDate()
    year       = date.getFullYear()
    raw_hour   = date.getHours()
    hour       = if raw_hour > 12 then raw_hour - 12 else raw_hour
    minute     = date.getMinutes()
    raw_second = date.getSeconds()
    second     = if raw_second < 10 then "0#{raw_second}" else raw_second
    meridiem   = if raw_hour < 12 then 'am' else 'pm'

    "#{month}/#{day}/#{year} #{hour}:#{minute}:#{second}#{meridiem}"

  render: ->
    if @collection.size() == 0
      @_renderOutOfVideos()
    else
      @_renderVideos()
    return @

  fetchVideos: () ->
    self = @

    @collection.fetch
      data:
        genre:  self.genre.id,
        offset: @calculateOffset()
      processData: true
      update: true
      remove: false
      success: (collection, response) ->
        self._stopVideoFetch()
        self.collection.update(collection.models)
        self.render()
      error: ->
        self._stopVideoFetch()
        self._renderLoadingError()

  updateVideoColor: (color) ->
    $('#current-video').css 'background-color', "##{color}"

  calculateOffset: ->
    offset = if @currentlyFetching then 10 else 0

  _setCurrentVideoIndex: (index) ->
    @currentVideoIndex = index

  _disableNextButton: ->
    $('button#next-video').attr 'disabled', true

  _enableNextButton: ->
    $('button#next-video').attr 'disabled', false

  _renderOutOfVideos: ->
    @$el.html 'No more videos in genre'

  _renderVideos: ->
    template = _.template $('#player-template').html()
    html     = template @currentVideo().toJSON()

    @$el.html html
    @updateVideoColor @currentVideo().get('color')
    @recordViewing()

  _renderLoadingError: ->
    @$el.html "Sorry, there was an error loading the videos."

  _stopVideoFetch: ->
    @currentlyFetching = false

  _startVideoFetch: ->
    @currentlyFetching = true
    @fetchVideos()
