Session.set('selectedUser', Meteor.user() || {_id: null, profile: {name: ''}})
Session.set('selectedYear', moment().year())

Deps.autorun ->
  Meteor.subscribe "coworkers", Meteor.userId()
  if Meteor.user() and Session.get('selectedUser')._id is null
    Session.set('selectedUser', Meteor.user())
