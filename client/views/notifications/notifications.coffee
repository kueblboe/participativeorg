Template.notifications.helpers
  notifications: ->
    Notifications.find()

  notificationCount: ->
    Notifications.find().count()