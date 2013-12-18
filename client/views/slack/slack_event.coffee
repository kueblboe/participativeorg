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

  highlightEffort: ->
    'highlight' if this.effort > 16

  highlightCost: ->
    'highlight' if this.cost > 500

  highlightRanking: ->
    'highlight' if this.ranking > 4

Template.slackEvent.events
  'click .item, tap .item': (e) ->
    $('#' + e.currentTarget.id).toggleClass('active')