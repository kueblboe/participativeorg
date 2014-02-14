Template.slackHomeAlert.events
  'click a': (e) ->
    e.preventDefault()
    Session.set('selectedUserId', @_id)