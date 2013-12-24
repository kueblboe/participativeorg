Template.slackEdit.helpers
  isActiveCategory: (category) ->
    if category is this.category
      'active'

Template.slackEdit.events
  "submit form": (e) ->
    e.preventDefault()
    currentSlackId = @_id
    slackProperties =
      title: $(e.target).find("#title").val()
      description: $(e.target).find("#description").val()
      category: $(e.target).find("#category .active input").val()
      date: new Date($(e.target).find("#date").val())
      effort: parseInt($(e.target).find("#effort").val(), 10)
      cost: parseInt($(e.target).find("#cost").val(), 10)
      url: $(e.target).find("#url").val()
      ranking: parseInt($(e.target).find("#ranking").val(), 10)
      copyOf: this.copyOf

    if currentSlackId
      Slack.update currentSlackId, { $set: slackProperties }, (error) ->
        if error
          throwError error.reason
        else
          Router.go "slack"
    else
      Meteor.call "addSlack", slackProperties, (error, id) ->
        if error
          throwError error.reason
        else
          Router.go "slack"

  "click .delete": (e) ->
    e.preventDefault()
    if confirm("Delete this slack?")
      Meteor.call 'removeSlack', @_id
      Router.go "slack"
