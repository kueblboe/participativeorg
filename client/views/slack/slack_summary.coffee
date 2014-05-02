setOrToggleSortOrder = (sortBy) ->
  if Session.get('slackSortBy') is sortBy
    Session.set('slackSortOrder', -Session.get('slackSortOrder'))
  else
    Session.set('slackSortBy', sortBy)

Template.slackSummary.helpers
  totalCost: ->
    Slack.find({ignoreCost: { $not: true }, date: { $gte: startOfYear(@year), $lte: endOfYear(@year) } }).fetch().map((s) -> s.cost).reduce(((c, sum) -> c + sum), 0)

  totalEffort: ->
    Slack.find({ignoreEffort: { $not: true }, date: { $gte: startOfYear(@year), $lte: endOfYear(@year) } }).fetch().map((s) -> s.effort).reduce(((e, sum) -> e + sum), 0)

  nextYear: ->
    parseInt(@year) + 1

  previousYear: ->
    parseInt(@year) - 1

  hasNextSlack: ->
    Slack.find({date: { $gte: startOfYear(@year + 1), $lte: endOfYear(@year + 1) } }).count() > 0

  hasPreviousSlack: ->
    Slack.find({date: { $gte: startOfYear(@year - 1), $lte: endOfYear(@year - 1) } }).count() > 0

  userId: ->
    Session.get('selectedUserId')

  isComplete: ->
    Completions.findOne()

  completionId: ->
    Completions.findOne()._id

Template.slackSummary.events
  'click #year': (e) ->
    e.preventDefault()
    setOrToggleSortOrder('date')

  'click #total-cost': (e) ->
    e.preventDefault()
    setOrToggleSortOrder('cost')

  'click #total-effort': (e) ->
    e.preventDefault()
    setOrToggleSortOrder('effort')

  'dblclick #total-effort': (e) ->
    e.preventDefault()
    effort = $('#total-effort').html()
    if effort.slice(-1) is 'h'
      Meteor.defer ->
        $('#total-effort').text("#{Math.round(effort.slice(0, -2) / 0.8) / 10 + ' d'}")

  'click #next-year': (e) ->
    e.preventDefault()
    Session.set('selectedYear', parseInt(@year) + 1)

  'click #last-year': (e) ->
    e.preventDefault()
    Session.set('selectedYear', parseInt(@year) - 1)

  'click #permalink': (e) ->
    window.prompt("Copy this link to share this page with others.", $(e.target).parent('#permalink').addBack('#permalink').attr('href'))

  'click #complete-year': (e) ->
    e.preventDefault()
    Meteor.call "completeYear", {year: @year}, (error, id) ->
      if error
        throwError error.reason
      else
        track('complete year', { 'year': @year })

  'click .uncomplete-year': (e) ->
    e.preventDefault()
    Completions.remove($(e.target).parents('.uncomplete-year').addBack('.uncomplete-year').attr('id'))