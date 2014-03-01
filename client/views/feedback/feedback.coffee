Session.set('feedbackSortBy', 'createdAt')
Session.set('feedbackSortOrder', -1)

Template.feedback.helpers
  hasFeedbackEvents: ->
    Feedback.find({receiver: Session.get('selectedUserId'), createdAt: { $gte: startOfYear(@year), $lte: endOfYear(@year) } }).count() > 0
    
  feedbackEvents: ->
    filter = {sort: {}}
    filter.sort[Session.get('feedbackSortBy')] = Session.get('feedbackSortOrder')
    Feedback.find({receiver: Session.get('selectedUserId'), createdAt: { $gte: startOfYear(@year), $lte: endOfYear(@year) } }, filter)

Template.feedback.events
  "click #opt-out": (e) ->
    Meteor.users.update(Meteor.userId(), { $set: {"profile.noFeedback": true} })
    track('opt out feedback')

  "click #opt-in": (e) ->
    Meteor.users.update(Meteor.userId(), { $unset: {"profile.noFeedback": ""} })
    track('opt in feedback')