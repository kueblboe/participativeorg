Handlebars.registerHelper "selectedSelf", ->
  Session.get('selectedUserId') is Meteor.userId()

Handlebars.registerHelper "formattedDate", (date) ->
  moment(date).format('DD.MM.YYYY')

Handlebars.registerHelper "rfcDate", (date) ->
  moment(date).format('YYYY-MM-DD')

Handlebars.registerHelper "ago", (date) ->
  moment(date).fromNow()

Handlebars.registerHelper "times", (n, block) ->
  accum = ""
  i = 0

  while i < n
    accum += block.fn(i)
    ++i
  accum

Handlebars.registerHelper "preview", (text) ->
  if text?.length > 50
    text.substring(0, 50) + '…'
  else
    text

Handlebars.registerHelper "avatar", (userId) ->
  user = Meteor.users.findOne(userId)
  if user?.profile.avatar
    user.profile.avatar
  else
    '/img/anonymous.png'

Handlebars.registerHelper "name", (userId) ->
  user = Meteor.users.findOne(userId)
  user?.profile?.name

Handlebars.registerHelper "categorySymbol", (category) ->
  if this.category is 'book'
    'book'
  else if this.category is 'event'
    'users'
  else
    'question-circle'

Handlebars.registerHelper "rankingNeg", (ranking) ->
  5 - ranking