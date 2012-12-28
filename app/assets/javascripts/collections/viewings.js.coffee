VideoSmash.Collections.Viewings = Backbone.Collection.extend
  model: VideoSmash.Models.Video
  url: -> '/viewings'
