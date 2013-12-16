Template.header.helpers(
  activeRouteClass: ->
    args = Array::slice.call(arguments, 0)
    args.pop()
    active = _.any(args, (name) ->
      Router.current().route.name is name
    )
    active and "active"

  users: ->
    Meteor.users.find()

  selectedUserName: ->
    Session.get('selectedUser').profile.name

  selectedSelf: ->
    Session.get('selectedUser')._id is Meteor.userId()
)

Template.header.events
  'click .dropdown-toggle': (e) ->
    e.preventDefault()

  'click .coworker': (e) ->
    e.preventDefault()
    Session.set('selectedUser', Meteor.users.findOne(@._id))