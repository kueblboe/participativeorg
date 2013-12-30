@Completions = new Meteor.Collection("completions")

Completions.allow
  update: ownsDocument
  remove: ownsDocument

Completions.deny update: (userId, completion, fieldNames) ->
  # may only edit the following fields:
  _.without(fieldNames, "year").length > 0

Meteor.methods(
  completeYear: (completionAttributes) ->
    # ensure the user is logged in
    throw new Meteor.Error(401, "You need to login to add a completion") unless Meteor.user()
    
    # pick out the whitelisted keys
    completion = _.extend(_.pick(completionAttributes, "year"),
      userId: Meteor.userId()
      createdAt: new Date()
    )

    # add completion and return id
    Completions.insert(completion)
)
