latestFeedback = (receiverId) ->
  Feedback.findOne({receiver: receiverId}, {sort: {createdAt: -1}})

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
    latestFeedback(@_id)?.createdAt

  latestFeedbackRecommend: ->
    latestFeedback(@_id)?.recommend

  latestFeedbackKnow: ->
    latestFeedback(@_id)?.know

  cellNames: ->
    if cellIds = userProfile(@_id)?.cells
      cellNames(cellIds)

Template.colleague.events
  'click a.feedback': (e) ->
    e.preventDefault()
    Session.set('selectedUserId', @_id)
    Router.go 'feedback'

  'click a.slack': (e) ->
    e.preventDefault()
    Session.set('selectedUserId', @_id)
    Router.go 'slack'

  'click a.profile': (e) ->
    e.preventDefault()
    Session.set('selectedUserId', @_id)
    Router.go 'profile'