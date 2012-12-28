window.VideoSmash =
  Models: {}
  Collections: {}
  Views: {}

_.extend(VideoSmash, Backbone.Events)

# use mustache-style templating
_.templateSettings =
  interpolate : /\{\{(.+?)\}\}/g
