isInMyDomain = (userId, currentUserId) ->
  user = Meteor.users.findOne(userId)
  me   = Meteor.users.findOne(currentUserId)
  user and me and user.profile.domain is me.profile.domain

Meteor.publish "slack", (userId) ->
  if isInMyDomain(userId, this.userId)
    Slack.find {userId: userId}

Meteor.publish "goals", (userId) ->
  if isInMyDomain(userId, this.userId)
    Goals.find {userId: userId}

Meteor.publish "coworkers", ->
  me =  Meteor.users.findOne(this.userId)
  if me
    Meteor.users.find { 'profile.domain': me.profile.domain }