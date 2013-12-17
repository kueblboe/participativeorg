Session.set('slackSortBy', 'date')
Session.set('slackSortOrder', -1)

Template.slack.helpers
  slackEvents: ->
    filter = {sort: {}}
    filter.sort[Session.get('slackSortBy')] = Session.get('slackSortOrder')
    Slack.find({}, filter)

  hasSlackEvents: ->
    Slack.find({}).count() > 0