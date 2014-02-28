Template.colleague.helpers
  relationSymbol: ->
    ''

  latestActivity: ->
    Meteor.users.findOne(@_id)?.profile.latestActivity?.action

  latestActivityLink: ->
    "/#{Meteor.users.findOne(@_id)?.profile.latestActivity?.link}"

  latestActivityDate: ->
    Meteor.users.findOne(@_id)?.profile.latestActivity?.date

  latestActivityIcon: ->
    Meteor.users.findOne(@_id)?.profile.latestActivity?.icon

  latestFeedbackDate: ->
    Feedback.findOne({receiver: @_id}, {sort: {createdAt: -1}})?.createdAt

Template.colleague.events
  'click a.feedback': (e) ->
    e.preventDefault()
    Session.set('selectedUserId', @_id)
    Router.go 'feedback'

  'click a.slack': (e) ->
    e.preventDefault()
    Session.set('selectedUserId', @_id)
    Router.go 'slack'