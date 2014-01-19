Template.slackEvent.helpers
  hashtagSymbol: ->
    if /#freizeit/.test(this.description)
      'moon-o'
    else if /#vortrag/.test(this.description)
      'bullhorn'
    else if /#ausland/.test(this.description)
      'suitcase'

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
    activeSlack = (Session.get('activeSlack') || [])
    index = activeSlack.indexOf(this._id)
    if index isnt -1
      activeSlack.splice(index, 1)
      $('#' + this._id).removeClass('active')
    else
      activeSlack = activeSlack.concat [this._id]
      $('#' + this._id).addClass('active')
    Session.set('activeSlack', activeSlack)

  'click .coworker': (e) ->
    e.preventDefault()
    Session.set('selectedUserId', this.userId)

Template.slackEvent.rendered = ->
  if _.contains((Session.get('activeSlack') || []), this.data._id)
    $('#' + this.data._id).addClass('active')