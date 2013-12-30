Template.header.helpers
  activeRouteClass: ->
    args = Array::slice.call(arguments, 0)
    args.pop()
    active = _.any(args, (name) ->
      Router.current().route.name is name
    )
    active and "active"

  users: ->
    Meteor.users.find({}, {sort: {'profile.name': 1}})

  selectedUserName: ->
    Meteor.users.findOne(Session.get('selectedUserId'))?.profile.name

  selectedUserAvatar: ->
    Meteor.users.findOne(Session.get('selectedUserId'))?.profile.avatar

Template.header.events
  'click .dropdown-toggle': (e) ->
    e.preventDefault()

  'click .coworker': (e) ->
    e.preventDefault()
    Session.set('selectedUserId', @._id)