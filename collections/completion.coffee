@Completions = new Meteor.Collection("completions")

Completions.allow
  update: ownsDocument
  remove: ownsDocument

Completions.deny update: (userId, completion, fieldNames) ->
  # may only edit the following fields:
  _.without(fieldNames, "year").length > 0

Meteor.methods(
  completeYear: (completionAttributes) ->
    throw new Meteor.Error(401, "You need to login to add a completion") unless Meteor.user()

    completion = pickWhitelistedAttributes(completionAttributes, "year")

    Completions.insert completion, (error) ->
      updateLatestActivity('check', 'marked slack activities as complete', "slack?userId=#{Meteor.userId()}") unless error
)
