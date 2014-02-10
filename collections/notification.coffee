@Notifications = new Meteor.Collection("notifications")

Notifications.allow
  update: ownsDocument

@createNotification = (notificationAttributes) ->
  if notificationAttributes.userId isnt Meteor.userId()
    notification = _.extend(_.pick(notificationAttributes, "userId", "action", "openEdit", "slackId", "goalId", "feedbackId"),
      read: false
      seen: false
      createdAt: new Date()
    )

    unless notificationAttributes.anonymous
      notification = _.extend(notification,
        commenterId: Meteor.userId()
      )

    Notifications.insert(notification)