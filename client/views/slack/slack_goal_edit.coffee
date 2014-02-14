Template.slackGoalEdit.events
  "submit form": (e) ->
    e.preventDefault()
    currentGoalId = @_id
    goalProperties =
      description: $(e.target).find("#description").val()
      date: new Date($(e.target).find("#date").val())

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
          track('add goal', { 'date': goalProperties.date })
          Router.go "slack"

  "click .delete": (e) ->
    e.preventDefault()
    if confirm("Delete this goal?")
      Goals.remove @_id
      Router.go "slack"
