setOrToggleSortOrder = (sortBy) ->
  if Session.get('colleagueSortBy') is sortBy
    Session.set('colleagueSortOrder', -Session.get('colleagueSortOrder'))
  else
    Session.set('colleagueSortBy', sortBy)

Template.colleagueSummary.helpers
  sortAsc: ->
    Session.get('colleagueSortOrder') > 0

  sortDesc: ->
    Session.get('colleagueSortOrder') < 0

Template.colleagueSummary.events
  'click #sort-asc': (e) ->
    e.preventDefault()
    Session.set('colleagueSortOrder', -1)

  'click #sort-desc': (e) ->
    e.preventDefault()
    Session.set('colleagueSortOrder', 1)

  'click #alphabetical': (e) ->
    e.preventDefault()
    setOrToggleSortOrder('profile.firstname')

  'click #activity': (e) ->
    e.preventDefault()
    setOrToggleSortOrder('profile.latestActivity.date')