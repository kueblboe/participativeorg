Template.commentAdd.events
  "submit form": (e) ->
    e.preventDefault()
    $body = $(e.target).find("#body")
    commentProperties =
      commentedId: @_id
      body: $body.val()

    Meteor.call "addComment", commentProperties, (error) ->
      if error
        throwError error.reason
      else
        track('add comment')
        $body.val('')