Template.likeLinks.events
  'click a.like': (e) ->
    e.preventDefault()
    e.stopPropagation()

    Meteor.call "addRemoveLike", {likedId: @_id}, (error) ->
      if error
        throwError error.reason
      else
        track('like')