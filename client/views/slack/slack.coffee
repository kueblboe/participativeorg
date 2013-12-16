Session.set('slackSortBy', 'date')
Session.set('slackSortOrder', -1)

Template.slack.helpers
  slackEvents: ->
    filter = {sort: {}}
    filter.sort[Session.get('slackSortBy')] = Session.get('slackSortOrder')
    Slack.find({userId: Meteor.userId()}, filter) if Meteor.user()