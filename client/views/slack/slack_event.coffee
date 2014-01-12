Template.slackEvent.helpers
  ownSlack: ->
    @userId is Meteor.userId()

  notPartYet: ->
    not this.copies or not _.contains(_.pluck(this.copies, 'userId'), Meteor.userId())

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

  unconfirmed: ->
    if !!this.indicatedBy then 'unconfirmed'

Template.slackEvent.events
  'click a.background-link': (e) ->
    e.preventDefault()
    $('#' + e.currentTarget.id.substring(5)).toggleClass('active')

  'click .coworker': (e) ->
    e.preventDefault()
    Session.set('selectedUserId', this.userId)