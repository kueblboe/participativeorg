Template.feedbackAdd.events
  "submit form": (e) ->
    e.preventDefault()
    $body = $(e.target).find("#body")
    $recommend = $(e.target).find("#recommend")
    $know = $(e.target).find("#know")
    feedbackProperties =
      receiver: Session.get('selectedUserId')
      body: $body.val()
      recommend: parseInt($recommend.val(), 10)
      know: parseInt($know.val(), 10)

    Meteor.call "addFeedback", feedbackProperties, (error) ->
      if error
        throwError error.reason
      else
        track('add feedback')
        $body.val('')
        $recommend.val('')
        $know.val('')