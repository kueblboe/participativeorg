initialUser = Meteor.user() || {_id: null, profile: {name: ''}}
Session.set('selectedUser', initialUser)

Deps.autorun ->
  Meteor.subscribe "goals", Session.get('selectedUser')._id
  Meteor.subscribe "coworkers", Meteor.userId()
  if Meteor.user() and Session.get('selectedUser')._id is null
    Session.set('selectedUser', Meteor.user())
