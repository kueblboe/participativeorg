Meteor.methods(
  addRemoveLike: (likeAttributes) ->
    throw new Meteor.Error(401, "You need to login to like something") unless Meteor.user()
    throw new Meteor.Error(422, "Can't figure out what you are liking") unless likeAttributes.likedId
    
    like =
      userId: Meteor.userId()
      createdAt: new Date()

    if slack = Slack.findOne(likeAttributes.likedId)
      if _.contains(_.pluck(slack.likes, 'userId'), Meteor.userId())
        updatedLikes = _.reject(slack.likes, (l) -> l.userId is Meteor.userId())
      else
        updatedLikes = (slack.likes || []).concat like
        createNotification({ slackId: slack._id, ownerUserId: slack.userId, userId: slack.userId, action: "likes your" })
      Slack.update(slack._id, { $set: {likes: updatedLikes} })
    else if goal = Goals.findOne(likeAttributes.likedId)
      if _.contains(_.pluck(goal.likes, 'userId'), Meteor.userId())
        updatedLikes = _.reject(goal.likes, (l) -> l.userId is Meteor.userId())
      else
        updatedLikes = (goal.likes || []).concat like
        createNotification({ goalId: goal._id, ownerUserId: goal.userId, userId: goal.userId, action: "likes your" })
      Goals.update(goal._id, { $set: {likes: updatedLikes} })
)