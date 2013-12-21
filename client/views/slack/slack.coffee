Session.set('slackSortBy', 'date')
Session.set('slackSortOrder', -1)

Template.slack.helpers
  hasSlackEvents: -> Slack.find().count() > 0
  hasGoals: -> Goals.find().count() > 0
  goals: -> Goals.find()

  slackEvents: ->
    filter = {sort: {}}
    filter.sort[Session.get('slackSortBy')] = Session.get('slackSortOrder')
    Slack.find({}, filter)