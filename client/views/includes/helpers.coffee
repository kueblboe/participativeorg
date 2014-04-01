@userProfile = (userId) ->
  Meteor.users.findOne(userId)?.profile

Handlebars.registerHelper "submitButtonText", ->
  if @_id then 'Edit' else 'Add'

Handlebars.registerHelper "selectedSelf", ->
  Session.get('selectedUserId') is Meteor.userId()

Handlebars.registerHelper "self", ->
  @_id is Meteor.userId()

Handlebars.registerHelper "owns", ->
  @userId is Meteor.userId()

Handlebars.registerHelper "formattedDate", (date) ->
  moment(date).format('DD.MM.YYYY')

Handlebars.registerHelper "rfcDate", (date) ->
  moment(date).format('YYYY-MM-DD')

Handlebars.registerHelper "times", (n, block) ->
  (block.fn(i) for i in [0...n]).join("")

Handlebars.registerHelper "preview", (text) ->
  if text?.length > 50 then text.substring(0, 50) + '…' else text

Handlebars.registerHelper "avatar", (userId) ->
  profile = userProfile(userId)
  if not userId? or not profile
    '/img/anonymous2.png'
  else if profile.avatar
    profile.avatar
  else
    '/img/anonymous.png'

Handlebars.registerHelper "name", (userId) ->
  userProfile(userId)?.name || 'someone'

Handlebars.registerHelper "firstname", (userId) ->
  userProfile(userId)?.firstname || 'someone'

Handlebars.registerHelper "domain", ->
  Meteor.user()?.profile.domain

Handlebars.registerHelper "firstnameSelectedUser", ->
  userProfile(Session.get('selectedUserId'))?.firstname

Handlebars.registerHelper "notPartOfYet", ->
  not @copies or not _.contains(_.pluck(@copies, 'userId'), Meteor.userId())

Handlebars.registerHelper "categorySymbol", ->
  if @category is 'read'
    'book'
  else if @category is 'attend'
    'users'
  else
    'question-circle'

Handlebars.registerHelper "rankingNeg", ->
  5 - @ranking

Handlebars.registerHelper "liker", ->
  ({userId: userId} for userId in _.uniq(_.pluck(@likes, 'userId')))

Handlebars.registerHelper "commenters", ->
  ({userId: userId} for userId in _.uniq(_.pluck(@comments, 'userId')))

Handlebars.registerHelper "commentersCount", ->
  _.uniq(_.pluck(@comments, 'userId')).length

Handlebars.registerHelper "commentsList", ->
  _.sortBy(@comments, (c) -> - c.createdAt)

Handlebars.registerHelper "likedByMe", ->
  _.contains(_.pluck(@likes, 'userId'), Meteor.userId())

Handlebars.registerHelper "unseenNotificationCount", ->
  Notifications.find({seen: false}).count()

Handlebars.registerHelper "isSlackNovice", ->
  not Meteor.user()?.profile.numSlack or Meteor.user().profile.numSlack < 4

Handlebars.registerHelper "hasOptedOutOfFeedback", ->
  userId = if typeof arguments[0] is "string" then arguments[0] else Session.get('selectedUserId')
  userProfile(userId)?.noFeedback

Handlebars.registerHelper "isNumber", (number) ->
  _.isNumber(number) and not _.isNaN(number)