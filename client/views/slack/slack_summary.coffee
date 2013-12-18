Template.slackSummary.helpers
  totalCost: ->
    if Meteor.userId() is 'MQpnyNnL2gT5Swyse'
      2960
    else
      1111
  totalEffort: ->
    if Meteor.userId() is 'MQpnyNnL2gT5Swyse'
      186
    else
      111
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