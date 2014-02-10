Template.header.helpers
  activeRouteClass: (args..., hash) ->
    if _.any(args, (name) -> Router.current().route.name is name)
      'active'

  users: ->
    Meteor.users.find({}, {sort: {'profile.name': 1}})

  selectedUserFirstname: ->
    Meteor.users.findOne(Session.get('selectedUserId'))?.profile.firstname

  selectedUserAvatar: ->
    Meteor.users.findOne(Session.get('selectedUserId'))?.profile.avatar

Template.header.events
  'click .dropdown-toggle': (e) ->
    e.preventDefault()

  'click .coworker': (e) ->
    e.preventDefault()
    Session.set('selectedUserId', this._id)
    track('view other slack', { 'user': this.profile.name }) unless this._id is Meteor.userId()

  'click #login-buttons-logout': (e) ->
    Router.go 'home'

Template.header.rendered = ->
  if Meteor.user()?
    $('#login-buttons-logout').html("<img class='img-circle avatar' src='#{Meteor.user().profile.avatar}'> See ya")