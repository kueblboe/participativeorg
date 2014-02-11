Template.feedback.helpers
  hasFeedbackEvents: ->
    Feedback.find({createdAt: { $gte: startOfYear(this.year), $lte: endOfYear(this.year) } }).count() > 0
    
  feedbackEvents: ->
    Feedback.find({createdAt: { $gte: startOfYear(this.year), $lte: endOfYear(this.year) } }, {sort: {createdAt: -1}})