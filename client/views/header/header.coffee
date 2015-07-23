Template.header.helpers
  activeRouteClass: (args..., hash) ->
    if _.any(args, (name) -> Router.current().route.getName() is name)
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

  'click #login': (e) ->
    Router.go 'login'

  'click #logout': (e) ->
    Meteor.logout (error) ->
      if error
        @throwError error.reason
      else
        Router.go 'home'

Template.header.rendered = ->
  $(".navbar-fixed-top").headroom()