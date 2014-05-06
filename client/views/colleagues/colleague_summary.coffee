setOrToggleSortOrder = (sortBy) ->
  if Session.get('colleagueSortBy') is sortBy
    Session.set('colleagueSortOrder', -Session.get('colleagueSortOrder'))
  else
    Session.set('colleagueSortBy', sortBy)

Template.colleagueSummary.events
  'click #alphabetical': (e) ->
    e.preventDefault()
    setOrToggleSortOrder('profile.name')

  'click #activity': (e) ->
    e.preventDefault()
    setOrToggleSortOrder('profile.latestActivity.date')