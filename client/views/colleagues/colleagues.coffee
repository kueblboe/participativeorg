Session.set('colleagueSortBy', 'profile.firstname')
Session.set('colleagueSortOrder', 1)

Template.colleagues.helpers
  me: ->
    Meteor.users.find({_id: Meteor.userId()})

  colleagueList: ->
    filter = {sort: {}}
    filter.sort[Session.get('colleagueSortBy')] = Session.get('colleagueSortOrder')
    Meteor.users.find({_id: { $ne: Meteor.userId() }}, filter)