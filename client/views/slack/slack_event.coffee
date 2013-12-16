Template.slackEvent.helpers
  ownSlack: ->
    @userId is Meteor.userId()

  categorySymbol: (category) ->
    if category is 'book'
      'book'
    else if category is 'event'
      'users'
    else
      'question-circle'