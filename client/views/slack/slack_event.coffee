Template.slackEvent.helpers
  unconfirmed: ->
    if !!@indicatedBy then 'unconfirmed'

Template.slackEvent.events
  'click a.background-link': (e) ->
    e.preventDefault()
    activeSlack = (Session.get('activeSlack') || [])
    index = activeSlack.indexOf(@_id)
    if index isnt -1
      activeSlack.splice(index, 1)
      $('#' + @_id).removeClass('active')
    else
      activeSlack.push @_id
      $('#' + @_id).addClass('active')
    Session.set('activeSlack', activeSlack)

  'click .coworker': (e) ->
    e.preventDefault()
    Router.go 'slackUser', {userId: @userId, year: moment(@date).year()}

Template.slackEvent.rendered = ->
  if _.contains((Session.get('activeSlack') || []), @data._id)
    $('#' + @data._id).addClass('active')