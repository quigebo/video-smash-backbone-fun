VideoSmash.Collections.Videos = Backbone.Collection.extend
  model: VideoSmash.Models.Video
  url: -> '/videos'
