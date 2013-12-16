initialUser =  Meteor.user() || {_id: null, profile: {name: ''}}
Session.set('selectedUser', initialUser)

Deps.autorun ->
  Meteor.subscribe "slack", Session.get('selectedUser')._id
  Meteor.subscribe "coworkers", Meteor.userId()
