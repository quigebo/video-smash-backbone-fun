VideoSmash.Views.PreviouslyViewed = Backbone.View.extend
  el: 'section#previously-viewed ul'

  initialize: ->
    @collection.on "add", @addNew, @
    @collection.on "reset", @reset, @
    @collection.on "fetch:success", @yey, @
    VideoSmash.on 'load:previouslyViewed', @load, @

  reset: ->
    @$el.html ''

  addNew: (viewing) ->
    template = _.template $('#previously-viewed-template').html()
    html = template viewing.toJSON()
    @$el.prepend html

  load: (genre_id) ->
    self = @
    @collection.fetch
      data:
        genre_id: genre_id
      processData: true
      success: (collection, response) ->
        self.render()

  render: ->
    self = @

    _.each @collection.models, (viewing) ->
      self.addNew viewing

    return @
