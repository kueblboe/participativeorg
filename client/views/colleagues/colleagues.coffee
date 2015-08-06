@ColleagueSearch = new SearchSource('colleagues', ['profile.firstname', 'profile.lastname'], {keepHistory: 1000 * 60 * 5, localSearch: true})

Session.set('colleagueSortBy', 'profile.firstname')
Session.set('colleagueSortOrder', 1)

setOrToggleSortOrder = (sortBy) ->
  if Session.get('colleagueSortBy') is sortBy
    Session.set('colleagueSortOrder', -Session.get('colleagueSortOrder'))
  else
    Session.set('colleagueSortBy', sortBy)

Tracker.autorun ->
  sort = {}
  sort[Session.get('colleagueSortBy')] = Session.get('colleagueSortOrder')
  Session.set('colleagueSort', sort)

Tracker.autorun ->
  ColleagueSearch.search Session.get('colleagueSearchTerm'), {sort: Session.get('colleagueSort')}

Template.colleagues.helpers
  isLoading: ->
    ColleagueSearch.getStatus().loading

  sortAsc: ->
    Session.get('colleagueSortOrder') > 0

  sortDesc: ->
    Session.get('colleagueSortOrder') < 0

  me: ->
    Meteor.users.find({_id: Meteor.userId()})

  colleagueList: ->
    ColleagueSearch.getData
      transform: (matchText, regExp) ->
        matchText.replace regExp, '<span class="search-text">$&</span>'
      sort: Session.get('colleagueSort')

Template.colleagues.events
  'keyup #search-box': _.throttle(((e) ->
    text = $(e.target).val().trim()
    Session.set('colleagueSearchTerm', text)
  ), 200)

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