Template.satisfactionAdd.events
  "submit form": (e) ->
    e.preventDefault()
    $body = $(e.target).find("#body")
    $score = $(e.target).find("#score")
    satisfactionProperties =
      body: $body.val()
      score: parseInt($score.val(), 10)

    Meteor.call "addSatisfaction", satisfactionProperties, (error) ->
      clearErrors()
      if error
        throwError error.reason
      else
        track('add satisfaction')
        $body.val('')
        $score.val('')