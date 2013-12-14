Meteor.publish "slack", (userId) ->
  user = Meteor.users.findOne(userId)
  me =  Meteor.users.findOne(this.userId)
  if user and me and user.profile.domain is me.profile.domain
    Slack.find {userId: userId}
