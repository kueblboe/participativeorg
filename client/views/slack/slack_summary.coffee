Template.slackSummary.helpers
  totalCost: ->
    if Meteor.userId() is 'MQpnyNnL2gT5Swyse'
      3006
    else if Meteor.userId() is 'FpX3CtJGsq96xPpr2'
      2349
    else
      '???'
  totalEffort: ->
    if Meteor.userId() is 'MQpnyNnL2gT5Swyse'
      202
    else if Meteor.userId() is 'FpX3CtJGsq96xPpr2'
      65
    else
      '???'
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