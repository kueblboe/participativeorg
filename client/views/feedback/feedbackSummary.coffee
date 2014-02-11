Template.feedbackSummary.helpers
  nextYear: ->
    parseInt(this.year) + 1

  previousYear: ->
    parseInt(this.year) - 1

  hasNextFeedback: ->
    Feedback.find({createdAt: { $gte: startOfYear(this.year + 1), $lte: endOfYear(this.year + 1) } }).count() > 0

  hasPreviousFeedback: ->
    Feedback.find({createdAt: { $gte: startOfYear(this.year - 1), $lte: endOfYear(this.year - 1) } }).count() > 0

Template.feedbackSummary.events
  'click #next-year': (e) ->
    e.preventDefault()
    Session.set('selectedYear', parseInt(this.year) + 1)

  'click #last-year': (e) ->
    e.preventDefault()
    Session.set('selectedYear', parseInt(this.year) - 1)