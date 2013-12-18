Template.slackSummary.helpers
  totalCost: -> 462
  totalEffort: -> 120
  goals: -> Goals.find()

Template.slackSummary.events
  'click #totalCost, tap #totalCost': (e) ->
    if Session.get('slackSortBy') is 'cost'
      Session.set('slackSortOrder', -Session.get('slackSortOrder'))
    else
      Session.set('slackSortBy', 'cost')

  'click #totalEffort, tap #totalEffort': (e) ->
    if Session.get('slackSortBy') is 'effort'
      Session.set('slackSortOrder', -Session.get('slackSortOrder'))
    else
      Session.set('slackSortBy', 'effort')

  'click #year, tap #year': (e) ->
    if Session.get('slackSortBy') is 'date'
      Session.set('slackSortOrder', -Session.get('slackSortOrder'))
    else
      Session.set('slackSortBy', 'date')