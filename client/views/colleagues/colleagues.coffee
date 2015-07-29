@ColleagueSearch = new SearchSource('colleagues', ['profile.firstname', 'profile.lastname'], {keepHistory: 1000 * 60 * 5, localSearch: true})

Session.set('colleagueSortBy', 'profile.firstname')
Session.set('colleagueSortOrder', 1)

Tracker.autorun ->
  sort = {}
  sort[Session.get('colleagueSortBy')] = Session.get('colleagueSortOrder')
  Session.set('colleagueSort', sort)

Tracker.autorun ->
  ColleagueSearch.search Session.get('colleagueSearchTerm'), {sort: Session.get('colleagueSort')}

Template.colleagues.helpers
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