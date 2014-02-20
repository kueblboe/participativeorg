Session.set('feedbackSortBy', 'createdAt')
Session.set('feedbackSortOrder', -1)

Template.feedback.helpers
  hasFeedbackEvents: ->
    Feedback.find({createdAt: { $gte: startOfYear(@year), $lte: endOfYear(@year) } }).count() > 0
    
  feedbackEvents: ->
    filter = {sort: {}}
    filter.sort[Session.get('feedbackSortBy')] = Session.get('feedbackSortOrder')
    Feedback.find({createdAt: { $gte: startOfYear(@year), $lte: endOfYear(@year) } }, filter)