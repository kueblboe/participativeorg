isInMyDomain = (userId, currentUserId) ->
  return true if userId is currentUserId
  user = Meteor.users.findOne(userId)
  me   = Meteor.users.findOne(currentUserId)
  user and me and user.profile.domain is me.profile.domain

Meteor.publish "slack", (userId, year) ->
  if isInMyDomain(userId, this.userId) and year
    [
      Slack.find({userId: userId, date: { $gte: startOfPreviousYear(year), $lte: endOfNextYear(year) } }),
      Completions.find({userId: userId, year: parseInt(year)}),
      Goals.find({userId: userId, date: { $gte: startOfPreviousYear(year), $lte: endOfNextYear(year) } })
    ]

Meteor.publish "singleSlack", (slackId) ->
  slack = Slack.find(slackId)
  if isInMyDomain(Slack.findOne(slackId).userId, this.userId) then slack else []

Meteor.publish "goal", (goalId) ->
  goal = Goals.find(goalId)
  if isInMyDomain(Goals.findOne(goalId).userId, this.userId) then goal else []

Meteor.publish "coworkers", ->
  me = Meteor.users.findOne(this.userId)
  if me
    Meteor.users.find { 'profile.domain': me.profile.domain }

Meteor.publish "notifications", -> Notifications.find({ userId: this.userId }, {sort: {createdAt: -1}, limit: 10})