Template.feedback.helpers
  hasFeedbackEvents: ->
    Feedback.find({createdAt: { $gte: startOfYear(@year), $lte: endOfYear(@year) } }).count() > 0
    
  feedbackEvents: ->
    Feedback.find({createdAt: { $gte: startOfYear(@year), $lte: endOfYear(@year) } }, {sort: {createdAt: -1}})