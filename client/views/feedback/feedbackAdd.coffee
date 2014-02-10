Template.feedbackAdd.events
  "submit form": (e) ->
    e.preventDefault()
    $body = $(e.target).find("#body")
    feedbackProperties =
      receiver: Session.get('selectedUserId')
      body: $body.val()

    Meteor.call "addFeedback", feedbackProperties, (error) ->
      if error
        throwError error.reason
      else
        track('add feedback')
        $body.val('')