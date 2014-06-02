Meteor.users.allow
  update: ownsDocument

Meteor.users.deny
  update: (userId, user, fieldNames) ->
    # may only edit the following fields:
    _.without(fieldNames, "profile").length > 0