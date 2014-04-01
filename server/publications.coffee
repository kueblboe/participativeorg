isInMyDomain = (userId, currentUserId) ->
  return true if userId is currentUserId
  user = Meteor.users.findOne(userId)
  me   = Meteor.users.findOne(currentUserId)
  user and me and user.profile.domain is me.profile.domain

Meteor.publish "slack", (userId, year) ->
  if isInMyDomain(userId, @userId) and year
    [
      Slack.find({userId: userId, date: { $gte: startOfPreviousYear(year), $lte: endOfNextYear(year) } }),
      Completions.find({userId: userId, year: parseInt(year)}),
      Goals.find({userId: userId, date: { $gte: startOfPreviousYear(year), $lte: endOfNextYear(year) } })
    ]

Meteor.publish "singleSlack", (slackId) ->
  slack = Slack.find(slackId)
  if isInMyDomain(Slack.findOne(slackId)?.userId, @userId) then slack else []

Meteor.publish "goal", (goalId) ->
  goal = Goals.find(goalId)
  if isInMyDomain(Goals.findOne(goalId)?.userId, @userId) then goal else []

Meteor.publish "feedback", (userId, year) ->
  if isInMyDomain(userId, @userId) and year
    if userId is @userId
      Feedback.find({receiver: userId, createdAt: { $gte: startOfPreviousYear(year), $lte: endOfNextYear(year) } }, {fields: {userId: 0}})
    else
      Feedback.find({userId: @userId, receiver: userId, createdAt: { $gte: startOfPreviousYear(year), $lte: endOfNextYear(year) } })

Meteor.publish "satisfaction", (month) ->
  if month
    Satisfaction.find({domain: Meteor.users.findOne(@userId).profile.domain, month: {$in: [previousMonth(month), month, nextMonth(month)]}}, {fields: {userId: 0}})

Meteor.publish "coworkers", ->
  me = Meteor.users.findOne(@userId)
  if me
    [
      Meteor.users.find({ 'profile.domain': me.profile.domain }),
      # TODO: only get the latest per colleague once aggreagtions are available
      Feedback.find({userId: @userId})
      Cells.find({ domain: me.profile.domain })
      Satisfaction.find({userId: @userId, month: {$in: [previousMonth(month()), month(), nextMonth(month())]}})
    ]

Meteor.publish "notifications", ->
  Notifications.find({ userId: @userId }, {sort: {createdAt: -1}, limit: 10})