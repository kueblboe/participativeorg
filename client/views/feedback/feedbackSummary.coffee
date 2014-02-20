setOrToggleSortOrder = (sortBy) ->
  if Session.get('feedbackSortBy') is sortBy
    Session.set('feedbackSortOrder', -Session.get('feedbackSortOrder'))
  else
    Session.set('feedbackSortBy', sortBy)

average = (mapping, year) ->
  feedback = Feedback.find({createdAt: { $gte: startOfYear(year), $lte: endOfYear(year) } }).fetch()
  feedbackWithMapping = _.filter(feedback.map(mapping), (x) -> x)
  Math.round(feedbackWithMapping.reduce(((x, sum) -> x + sum), 0) * 10 / feedbackWithMapping.length) / 10

Template.feedbackSummary.helpers
  averageRecommend: ->
    average(((f) -> f.recommend), @year)

  averageKnow: ->
    average(((f) -> f.know), @year)

  nextYear: ->
    parseInt(@year) + 1

  previousYear: ->
    parseInt(@year) - 1

  hasNextFeedback: ->
    Feedback.find({createdAt: { $gte: startOfYear(@year + 1), $lte: endOfYear(@year + 1) } }).count() > 0

  hasPreviousFeedback: ->
    Feedback.find({createdAt: { $gte: startOfYear(@year - 1), $lte: endOfYear(@year - 1) } }).count() > 0

Template.feedbackSummary.events
  'click #year': (e) ->
    e.preventDefault()
    setOrToggleSortOrder('createdAt')

  'click #average-recommend': (e) ->
    e.preventDefault()
    setOrToggleSortOrder('recommend')

  'click #average-know': (e) ->
    e.preventDefault()
    setOrToggleSortOrder('know')

  'click #next-year': (e) ->
    e.preventDefault()
    Session.set('selectedYear', parseInt(@year) + 1)

  'click #last-year': (e) ->
    e.preventDefault()
    Session.set('selectedYear', parseInt(@year) - 1)