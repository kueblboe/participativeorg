Meteor.methods(
  addComment: (commentAttributes) ->
    throw new Meteor.Error(401, "You need to login to add a comment") unless Meteor.user()
    throw new Meteor.Error(422, "Please fill in a message") unless commentAttributes.body
    throw new Meteor.Error(422, "Can't figure out what you are trying to comment on") unless commentAttributes.commentedId
    
    # pick out the whitelisted keys and add userId and createdAt
    comment = _.extend(_.pick(commentAttributes, "body"),
      userId: Meteor.userId()
      createdAt: new Date()
    )

    if slack = Slack.findOne(commentAttributes.commentedId)
      Slack.update(slack._id, { $set: {comments: (slack.comments || []).concat comment} })
      createNotification({ slackId: slack._id, userId: slack.userId, action: "commented on your" })
      for userId in _.reject(_.uniq(_.pluck(slack.comments, 'userId')), (id) -> id is slack.userId)
        createNotification({ slackId: slack._id, userId: userId, action: "also commented on" })
    else if goal = Goals.findOne(commentAttributes.commentedId)
      Goals.update(goal._id, { $set: {comments: (goal.comments || []).concat comment} })
      createNotification({ goalId: goal._id, userId: goal.userId, action: "commented on your" })
      for userId in _.reject(_.uniq(_.pluck(goal.comments, 'userId')), (id) -> id is goal.userId)
        createNotification({ goalId: goal._id, userId: userId, action: "also commented on" })
)