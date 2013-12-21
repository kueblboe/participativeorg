Template.slackGoalEdit.events
  "submit form": (e) ->
    e.preventDefault()
    currentGoalId = @_id
    goalProperties =
      description: $(e.target).find("#description").val()

    if currentGoalId
      Goals.update currentGoalId, { $set: goalProperties }, (error) ->
        if error
          throwError error.reason
        else
          Router.go "slack"
    else
      Meteor.call "addGoal", goalProperties, (error, id) ->
        if error
          throwError error.reason
        else
          Router.go "slack"

  "click .delete": (e) ->
    e.preventDefault()
    if confirm("Delete this goal?")
      currentGoalId = @_id
      Goals.remove currentGoalId
      Router.go "slack"
