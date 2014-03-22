Template.feedbackEvent.helpers
  replyPlaceholder: ->
    if @userId is Meteor.userId()
      'Reply with the goal of clarification, not justification.'
    else
      'Ask with the goal of clarification, not justification. Try not to be defensive about the received feedback.'

  replyButtonText: ->
    if @userId is Meteor.userId()
      'Reply'
    else
      'Ask'

  repliesWithUserIds: ->
    (_.defaults(reply, {userId: @userId}) for reply in @replies) if @replies

  recommendCategory: ->
    if @recommend > 8
      'promote'
    else if @recommend < 7
      'detract'
    else
      'indifferent'

Template.feedbackEvent.events
  "click a.reply": (e) ->
    e.preventDefault()
    $(e.target).parents('.item').find("li.reply").height(155)

  "submit .reply-form": (e) ->
    e.preventDefault()
    $body = $(e.target).find("#body")
    replyProperties =
      replyTo: @_id
      body: $body.val()
      anonymous: @userId is Meteor.userId()

    Meteor.call "addReply", replyProperties, (error) ->
      if error
        throwError error.reason
      else
        track('add feedback reply')
        $body.val('')
        $(e.target).parent().height(0)

  "click a.thank": (e) ->
    e.preventDefault()
    Meteor.call "thank", { replyTo: @_id }, (error) ->
      if error
        throwError error.reason
      else
        track('thanked for feedback')