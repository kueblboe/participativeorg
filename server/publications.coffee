isInMyDomain = (userId, currentUserId) ->
  return true if userId is currentUserId
  user = Meteor.users.findOne(userId)
  me   = Meteor.users.findOne(currentUserId)
  user and me and user.profile.domain is me.profile.domain

Meteor.publish "singleSlack", (slackId) -> Slack.find(slackId)

Meteor.publish "slack", (userId, year) ->
  if isInMyDomain(userId, this.userId) and year
    Slack.find {userId: userId, date: { $gte: startOfPreviousYear(year), $lte: endOfNextYear(year) } }

Meteor.publish "goal", (goalId) -> Goals.find(goalId)

Meteor.publish "goals", (userId, year) ->
  if isInMyDomain(userId, this.userId) and year
    Goals.find {userId: userId, date: { $gte: startOfPreviousYear(year), $lte: endOfNextYear(year) } }

Meteor.publish "completions", (userId, year) ->
  if isInMyDomain(userId, this.userId) and year
    Completions.find {userId: userId, year: parseInt(year)}

Meteor.publish "coworkers", ->
  me =  Meteor.users.findOne(this.userId)
  if me
    Meteor.users.find { 'profile.domain': me.profile.domain }