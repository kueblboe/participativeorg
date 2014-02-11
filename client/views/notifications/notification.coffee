Template.notification.helpers
  notificationItemPath: ->
    if this.openEdit and this.slackId
      Router.routes.slackEdit.path _id: this.slackId
    else if this.slackId
      Router.routes.slackPage.path _id: this.slackId
    else if this.goalId
      Router.routes.slackGoalPage.path _id: this.goalId
    else if this.feedbackId
      Router.routes.feedback.path()

  actedOnItem: ->
    if this.slackId
      "slack activity"
    else if this.goalId
      "goal"
    else if this.feedbackId
      "feedback"

  read: ->
    if this.read then 'read' else 'unread'

Template.notification.events
  "click a": ->
    Notifications.update(this._id, { $set: { read: true } })
    Session.set('selectedUserId', this.ownerUserId) if this.ownerUserId