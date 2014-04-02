#TODO: Change this to only allow setting cells
Meteor.users.allow
  update: (userId, user, fieldNames, modifier) ->
    true

Meteor.users.deny
  update: (userId, user, fieldNames) ->
    # may only edit the following fields:
    _.without(fieldNames, "profile").length > 0