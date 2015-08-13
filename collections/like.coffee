alreadyLiked = (liked) ->
  _.contains(_.pluck(liked.likes, 'userId'), Meteor.userId())

updateLikeList = (liked, like) ->
  if alreadyLiked(liked)
    _.reject(liked.likes, (l) -> l.userId is Meteor.userId())
  else
    (liked.likes || []).concat like

announce = (liked, likedType, basePath) ->
  updateLatestActivity('thumbs-up', "liked a #{likedType}", "#{basePath}/#{liked._id}?userId=#{liked.userId}")
  createNotification({ slackId: liked._id, ownerUserId: liked.userId, userId: liked.userId, action: "likes your" })

Meteor.methods(
  addRemoveLike: (likeAttributes) ->
    throw new Meteor.Error(401, "You need to login to like something") unless Meteor.user()
    throw new Meteor.Error(422, "Can't figure out what you are liking") unless likeAttributes.likedId

    like =
      userId: Meteor.userId()
      createdAt: new Date()

    if liked = Slack.findOne(likeAttributes.likedId)
      Collection = Slack
    else if liked = Goals.findOne(likeAttributes.likedId)
      Collection = Goals

    Collection.update liked._id, { $set: {likes: updateLikeList(liked, like)} }, (error) ->
      unless error or alreadyLiked(liked)
        if Collection._name is 'slack'
          updateLatestActivity('thumbs-up', "liked a personal development activity", "pd/#{liked._id}?userId=#{liked.userId}")
          createNotification({ slackId: liked._id, ownerUserId: liked.userId, userId: liked.userId, action: "likes your" })
        else if Collection._name is 'goals'
          updateLatestActivity('thumbs-up', "liked a goal", "pd/goal/#{liked._id}?userId=#{liked.userId}")
          createNotification({ goalId: liked._id, ownerUserId: liked.userId, userId: liked.userId, action: "likes your" })
)