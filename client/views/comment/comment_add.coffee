Template.commentAdd.events
  "submit form": (e) ->
    e.preventDefault()
    $body = $(e.target).find("#body")
    commentProperties =
      slackId: @_id
      body: $body.val()

    Meteor.call "addSlackComment", commentProperties, (error) ->
      if error
        throwError error.reason
      else
        $body.val('')