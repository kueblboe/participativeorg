Template.colleague.helpers
  relationSymbol: ->
    ''

  latestActivity: ->
    userProfile(@_id)?.latestActivity?.action

  latestActivityLink: ->
    "/#{userProfile(@_id)?.latestActivity?.link}"

  latestActivityDate: ->
    userProfile(@_id)?.latestActivity?.date

  latestActivityIcon: ->
    userProfile(@_id)?.latestActivity?.icon

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