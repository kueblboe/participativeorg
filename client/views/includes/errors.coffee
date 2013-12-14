Template.errors.helpers errors: ->
  Errors.find()

Template.error.rendered = ->
  error = @data
  Meteor.defer ->
    Errors.update error._id, {$set: {seen: true}}

