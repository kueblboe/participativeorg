Template.notification.helpers
  notificationItemPath: ->
    if @openEdit and @slackId
      Router.routes.slackEdit.path _id: @slackId
    else if @slackId
      Router.routes.slackPage.path _id: @slackId
    else if @goalId
      Router.routes.slackGoalPage.path _id: @goalId
    else if @feedbackId
      Router.routes.feedback.path()

  actedOnItem: ->
    if @slackId
      "slack activity"
    else if @goalId
      "goal"
    else if @feedbackId
      "feedback"

  read: ->
    if @read then 'read' else 'unread'

Template.notification.events
  "click a": ->
    Notifications.update(@_id, { $set: { read: true } })
    Session.set('selectedUserId', @ownerUserId) if @ownerUserId