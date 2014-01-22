Template.notifications.helpers
  notifications: ->
    Notifications.find({}, {sort: {createdAt: -1}})

  notificationCount: ->
    Notifications.find().count()

  seen: ->
    'unseen' if _.contains(_.pluck(Notifications.find().fetch(), 'seen'), false)

Template.notifications.events
  'click a.dropdown-toggle': ->
    Session.set('notificationsOpen', true)
    for notification in Notifications.find().fetch() when not notification.seen
      Notifications.update notification._id, { $set: {seen: true} }, (error) ->
        if error
          throwError error.reason

Template.slackEvent.rendered = ->
  if Session.get('notificationsOpen')
    $('#notifications').addClass('open')