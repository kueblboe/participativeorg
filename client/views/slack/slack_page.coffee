Template.slackPage.helpers
  commentsList: ->
    _.sortBy(this.comments, (c) -> - c.createdAt)