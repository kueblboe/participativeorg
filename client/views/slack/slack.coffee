Session.set('slackSortBy', 'date')
Session.set('slackSortOrder', -1)

Template.slack.helpers
  hasSlackEvents: ->
    Slack.find().count() > 0

  hasGoals: ->
    Goals.find({date: { $gte: startOfYear(this.year), $lte: endOfYear(this.year) } }).count() > 0

  goals: -> 
    Goals.find({date: { $gte: startOfYear(this.year), $lte: endOfYear(this.year) } })

  slackEvents: ->
    filter = {sort: {}}
    filter.sort[Session.get('slackSortBy')] = Session.get('slackSortOrder')
    Slack.find({date: { $gte: startOfYear(this.year), $lte: endOfYear(this.year) } }, filter)