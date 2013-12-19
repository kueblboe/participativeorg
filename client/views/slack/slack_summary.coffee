Template.slackSummary.helpers
  totalCost: -> Slack.find().fetch().map((s) -> s.cost).reduce((c, sum) -> c + sum)
  totalEffort: -> Slack.find().fetch().map((s) -> s.effort).reduce((e, sum) -> e + sum)
  goals: -> Goals.find()

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