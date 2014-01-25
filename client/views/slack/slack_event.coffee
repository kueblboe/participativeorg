Template.slackEvent.helpers
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