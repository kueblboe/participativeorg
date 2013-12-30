Template.slackSummary.helpers
  totalCost: -> Slack.find({date: { $gte: startOfYear(this.year), $lte: endOfYear(this.year) } }).fetch().map((s) -> s.cost).reduce(((c, sum) -> c + sum), 0)
  totalEffort: -> Slack.find({date: { $gte: startOfYear(this.year), $lte: endOfYear(this.year) } }).fetch().map((s) -> s.effort).reduce(((e, sum) -> e + sum), 0)
  nextYear: -> parseInt(this.year) + 1
  previousYear: -> parseInt(this.year) - 1
  hasNextSlack: -> Slack.find({date: { $gte: startOfYear(this.year + 1), $lte: endOfYear(this.year + 1) } }).count() > 0
  hasPreviousSlack: -> Slack.find({date: { $gte: startOfYear(this.year - 1), $lte: endOfYear(this.year - 1) } }).count() > 0

Template.slackSummary.events
  'click #totalCost': (e) ->
    e.preventDefault()
    if Session.get('slackSortBy') is 'cost'
      Session.set('slackSortOrder', -Session.get('slackSortOrder'))
    else
      Session.set('slackSortBy', 'cost')

  'click #totalEffort': (e) ->
    e.preventDefault()
    if Session.get('slackSortBy') is 'effort'
      Session.set('slackSortOrder', -Session.get('slackSortOrder'))
    else
      Session.set('slackSortBy', 'effort')

  'click #year': (e) ->
    e.preventDefault()
    if Session.get('slackSortBy') is 'date'
      Session.set('slackSortOrder', -Session.get('slackSortOrder'))
    else
      Session.set('slackSortBy', 'date')