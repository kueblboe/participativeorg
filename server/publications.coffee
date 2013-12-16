Meteor.publish "slack", (userId) ->
  user = Meteor.users.findOne(userId)
  me =  Meteor.users.findOne(this.userId)
  if user and me and user.profile.domain is me.profile.domain
    Slack.find {userId: userId}

Meteor.publish "coworkers", ->
  me =  Meteor.users.findOne(this.userId)
  if me
    Meteor.users.find { 'profile.domain': me.profile.domain }