Template.header.helpers
  activeRouteClass: (args..., hash) ->
    if _.any(args, (name) -> Router.current().route.name is name)
      'active'

  users: ->
    Meteor.users.find({}, {sort: {'profile.name': 1}})

  selectedUserFirstname: ->
    userProfile(Session.get('selectedUserId'))?.firstname

  selectedUserAvatar: ->
    userProfile(Session.get('selectedUserId'))?.avatar

Template.header.events
  'click .dropdown-toggle': (e) ->
    e.preventDefault()

  'click .coworker': (e) ->
    e.preventDefault()
    Session.set('selectedUserId', @_id)
    track('view other slack', { 'user': @profile.name }) unless @_id is Meteor.userId()

  'click #login-buttons-logout': (e) ->
    Router.go 'home'

Template.header.rendered = ->
  $(".navbar-fixed-top").headroom()
  if Meteor.user()?
    $('#login-buttons-logout').html("<img class='img-circle avatar' src='#{Meteor.user().profile.avatar}'> See ya")