@Slack = new Meteor.Collection("slack")

Slack.allow
  update: ownsDocument
  remove: ownsDocument

Slack.deny update: (userId, slack, fieldNames) ->
  # may only edit the following fields:
  _.without(fieldNames, "title", "description", "category", "date", "effort", "cost", "url", "ranking").length > 0

Meteor.methods(
  addSlack: (slackAttributes) ->
    throw new Meteor.Error(401, "You need to login to add slack") unless Meteor.user()
    throw new Meteor.Error(422, "Please fill in a title") unless slackAttributes.title
    
    # pick out the whitelisted keys and add userId and createdAt
    slack = _.extend(_.pick(slackAttributes, "title", "description", "category", "date", "effort", "cost", "url", "ranking"),
      userId: Meteor.userId()
      createdAt: new Date()
    )

    if slackAttributes.copyOf
      original = Slack.findOne(slackAttributes.copyOf)
      slack.copies = _.without(_.union(original.copies, {slackId: original._id, userId: original.userId}), null, undefined)

    newSlackId = Slack.insert(slack)

    if slackAttributes.copyOf
      Slack.update(original._id, { $set: {copies: _.without(_.union(original.copies, {slackId: newSlackId, userId: Meteor.userId()}), null, undefined)} })

    newSlackId
)
