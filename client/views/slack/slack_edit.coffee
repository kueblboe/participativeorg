Template.slackEdit.events
  "submit form": (e) ->
    e.preventDefault()
    currentSlackId = @_id
    slackProperties =
      title: $(e.target).find("#title").val()
      description: $(e.target).find("#description").val()
      category: $(e.target).find("#category").val()
      date: $(e.target).find("#date").val()
      effort: $(e.target).find("#effort").val()
      cost: $(e.target).find("#cost").val()

    if currentSlackId
      console.log "Updating"
      Slack.update currentSlackId, { $set: slackProperties }, (error) ->
        if error
          throwError error.reason
        else
          Router.go "slack"
    else
      console.log "Adding"
      Meteor.call "addSlack", slackProperties, (error, id) ->
        if error
          throwError error.reason
        else
          Router.go "slack"

  "click .delete": (e) ->
    e.preventDefault()
    if confirm("Delete this slack?")
      currentSlackId = @_id
      Slack.remove currentSlackId
      Router.go "slack"
