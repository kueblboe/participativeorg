Template.notification.helpers
  notificationItemPath: ->
    if this.slackId
      Router.routes.slackPage.path _id: this.slackId
    else if this.goalId
      Router.routes.slackGoalPage.path _id: this.goalId

  commentedItem: ->
    if this.slackId
      "slack activity"
    else if this.goalId
      "goal"

Template.notification.events
  "click a": ->
    Notifications.update(this._id, { $set: { read: true } })