@Slack = new Meteor.Collection("slack")

Meteor.methods(
  addSlack: (slackAttributes) ->
    # ensure the user is logged in
    throw new Meteor.Error(401, "You need to login to add slack") unless Meteor.user()
    
    # ensure the slack has a title
    throw new Meteor.Error(422, "Please fill in a title") unless slackAttributes.title
    
    # pick out the whitelisted keys
    slack = _.extend(_.pick(slackAttributes, "title", "description", "category", "date", "effort", "cost"),
      userId: Meteor.userId()
      createdAt: new Date()
    )

    # add slack and return id
    Slack.insert(slack)
)
