Template.slackEvent.helpers
  ownSlack: ->
    @userId is Meteor.userId()
