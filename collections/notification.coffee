@Notifications = new Meteor.Collection("notifications")

Notifications.allow
  update: ownsDocument

@createNotification = (notificationAttributes) ->
  if notificationAttributes.userId isnt Meteor.userId()
    notification = _.extend(_.pick(notificationAttributes, "userId", "action", "slackId", "goalId"),
      commenterId: Meteor.userId()
      read: false
    )

    Notifications.insert(notification)