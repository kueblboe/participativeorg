otherCommenters = (commented) ->
  _.reject(_.uniq(_.pluck(commented.comments, 'userId')), (id) -> id is commented.userId)

Meteor.methods(
  addComment: (commentAttributes) ->
    throw new Meteor.Error(401, "You need to login to add a comment") unless Meteor.user()
    throw new Meteor.Error(422, "Please fill in a message") unless commentAttributes.body
    throw new Meteor.Error(422, "Can't figure out what you are trying to comment on") unless commentAttributes.commentedId

    comment = pickWhitelistedAttributes(commentAttributes, "body")

    if commented = Slack.findOne(commentAttributes.commentedId)
      Collection = Slack
    else if commented = Goals.findOne(commentAttributes.commentedId)
      Collection = Goals

    Collection.update commented._id, { $set: {comments: (commented.comments || []).concat comment} }, (error) ->
      unless error
        if Collection._name is 'slack'
          updateLatestActivity('comment-o', 'commented on a slack activity', "slack/#{commented._id}?userId=#{commented.userId}")
          createNotification({ slackId: commented._id, ownerUserId: commented.userId, userId: commented.userId, action: "commented on your" })
          for userId in otherCommenters(commented)
            createNotification({ slackId: commented._id, ownerUserId: commented.userId, userId: userId, action: "also commented on" })
        else if Collection._name is 'goals'
          updateLatestActivity('comment-o', 'commented on a goal', "slack/goal/#{commented._id}?userId=#{commented.userId}")
          createNotification({ goalId: commented._id, ownerUserId: commented.userId, userId: commented.userId, action: "commented on your" })
          for userId in otherCommenters(commented)
            createNotification({ goalId: commented._id, ownerUserId: commented.userId, userId: userId, action: "also commented on" })
)