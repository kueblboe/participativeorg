Template.feedbackEvent.helpers
  replyPlaceholder: ->
    if this.userId is Meteor.userId()
      'Reply with the goal of clarification, not justification.'
    else
      'Ask with the goal of clarification, not justification. Try not to be defensive about the received feedback.'

  replyButtonText: ->
    if this.userId is Meteor.userId()
      'Reply'
    else
      'Ask'

Template.feedbackEvent.events
  "click a.reply": (e) ->
    e.preventDefault()
    $(e.target).parents('li.item').find("li.reply").height(95)

  "submit .reply-form": (e) ->
    e.preventDefault()
    $body = $(e.target).find("#body")
    replyProperties =
      replyTo: @_id
      body: $body.val()
      anonymous: this.userId is Meteor.userId()

    Meteor.call "addReply", replyProperties, (error) ->
      if error
        throwError error.reason
      else
        track('add feedback reply')
        $body.val('')
        $(e.target).parent().height(0)