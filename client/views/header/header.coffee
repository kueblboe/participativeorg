Template.header.helpers
  activeRouteClass: (args..., hash) ->
    if _.any(args, (name) -> Router.current().route.name is name)
      'active'

  users: ->
    Meteor.users.find({}, {sort: {'profile.firstname': 1, 'profile.lastname': 1}})

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
    track('view other slack', { 'user': @profile.firstname + " " + @profile.lastname }) unless @_id is Meteor.userId()

  'click #login-buttons-logout': (e) ->
    Router.go 'home'

  'click #main-nav>li': (e) ->
    Session.set('selectedUserId', Meteor.userId())

Template.header.rendered = ->
  $(".navbar-fixed-top").headroom()
  if Meteor.user()?
    $('#login-buttons-logout').html("<img class='img-circle avatar' src='#{Meteor.user().profile.avatar}'> See ya")