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
    Session.get('selectedUser').profile.name

  selectedUserAvatar: ->
    Session.get('selectedUser').profile.avatar

Template.header.events
  'click .dropdown-toggle': (e) ->
    e.preventDefault()

  'click .coworker': (e) ->
    e.preventDefault()
    Session.set('selectedUser', Meteor.users.findOne(@._id))