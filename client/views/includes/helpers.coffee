Handlebars.registerHelper "selectedSelf", ->
  Session.get('selectedUserId') is Meteor.userId()

Handlebars.registerHelper "formattedDate", (date) ->
  moment(date).format('DD.MM.YYYY')

Handlebars.registerHelper "rfcDate", (date) ->
  moment(date).format('YYYY-MM-DD')

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

Handlebars.registerHelper "owns", ->
    this.userId is Meteor.userId()

Handlebars.registerHelper "notPartYet", ->
    not this.copies or not _.contains(_.pluck(this.copies, 'userId'), Meteor.userId())

Handlebars.registerHelper "name", (userId) ->
  user = Meteor.users.findOne(userId)
  user?.profile?.name

Handlebars.registerHelper "categorySymbol", ->
  if this.category is 'book'
    'book'
  else if this.category is 'event'
    'users'
  else
    'question-circle'

Handlebars.registerHelper "rankingNeg", ->
  5 - this.ranking

Handlebars.registerHelper "liker", ->
  ({userId: userId} for userId in _.uniq(_.pluck(this.likes, 'userId')))

Handlebars.registerHelper "commenters", ->
  ({userId: userId} for userId in _.uniq(_.pluck(this.comments, 'userId')))

Handlebars.registerHelper "commentersCount", ->
  _.uniq(_.pluck(this.comments, 'userId')).length

Handlebars.registerHelper "commentsList", ->
  _.sortBy(this.comments, (c) -> - c.createdAt)

Handlebars.registerHelper "likedByMe", ->
  _.contains(_.pluck(this.likes, 'userId'), Meteor.userId())

Handlebars.registerHelper "notificationCount", ->
  Notifications.find().count()