Session.set('slackSortBy', 'date')
Session.set('slackSortOrder', -1)
year = -> Session.get('selectedYear')

Template.slack.helpers
  hasSlackEvents: ->
    Slack.find().count() > 0

  hasGoals: ->
    Goals.find({date: { $gte: startOfYear(year()), $lte: endOfYear(year()) } }).count() > 0

  goals: ->
    Goals.find({date: { $gte: startOfYear(year()), $lte: endOfYear(year()) } })

  slackEvents: ->
    filter = {sort: {}}
    filter.sort[Session.get('slackSortBy')] = Session.get('slackSortOrder')
    Slack.find({date: { $gte: startOfYear(year()), $lte: endOfYear(year()) } }, filter)