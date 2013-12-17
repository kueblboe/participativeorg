Template.slackEvent.helpers
  ownSlack: ->
    @userId is Meteor.userId()

  categorySymbol: ->
    if this.category is 'book'
      'book'
    else if this.category is 'event'
      'users'
    else
      'question-circle'

  rankingNeg: ->
    5 - this.ranking