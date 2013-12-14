Template.slack.helpers
  slackEvents: ->
    Slack.find({userId: Meteor.userId()}, {sort: {date: -1}}) if Meteor.user()