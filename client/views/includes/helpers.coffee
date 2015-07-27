@userProfile = (userId) ->
  Meteor.users.findOne(userId)?.profile

UI.registerHelper "submitButtonText", ->
  if @_id then 'Edit' else 'Add'

UI.registerHelper "selectedSelf", ->
  Session.get('selectedUserId') is Meteor.userId()

UI.registerHelper "self", ->
  @_id is Meteor.userId()

UI.registerHelper "owns", ->
  @userId is Meteor.userId()

UI.registerHelper "formattedDate", (date) ->
  moment(date).format('DD.MM.YYYY')

UI.registerHelper "rfcDate", (date) ->
  moment(date).format('YYYY-MM-DD')

UI.registerHelper "preview", (text) ->
  if text?.length > 50 then text.substring(0, 50) + '…' else text

UI.registerHelper "avatar", (userId) ->
  profile = userProfile(userId)
  if not userId? or not profile
    '/img/anonymous2.png'
  else if profile.avatar
    profile.avatar
  else
    '/img/anonymous.png'

UI.registerHelper "name", (userId) ->
  "#{userProfile(userId)?.firstname} #{userProfile(userId)?.lastname}" || 'someone'

UI.registerHelper "firstname", (userId) ->
  userProfile(userId)?.firstname || 'someone'

UI.registerHelper "domain", ->
  Meteor.user()?.domain

UI.registerHelper "domainString", ->
  Meteor.user()?.domain?.replace(/\./g,'-')

UI.registerHelper "firstnameSelectedUser", ->
  userProfile(Session.get('selectedUserId'))?.firstname

UI.registerHelper "notPartOfYet", ->
  not @copies or not _.contains(_.pluck(@copies, 'userId'), Meteor.userId())

UI.registerHelper "categorySymbol", ->
  if @category is 'read'
    'book'
  else if @category is 'attend'
    'users'
  else
    'question-circle'

UI.registerHelper "liker", ->
  ({userId: userId} for userId in _.uniq(_.pluck(@likes, 'userId')))

UI.registerHelper "commenters", ->
  ({userId: userId} for userId in _.uniq(_.pluck(@comments, 'userId')))

UI.registerHelper "commentersCount", ->
  _.uniq(_.pluck(@comments, 'userId')).length

UI.registerHelper "commentsList", ->
  _.sortBy(@comments, (c) -> - c.createdAt)

UI.registerHelper "likedByMe", ->
  _.contains(_.pluck(@likes, 'userId'), Meteor.userId())

UI.registerHelper "unseenNotificationCount", ->
  Notifications.find({seen: false}).count()

UI.registerHelper "isSlackNovice", ->
  not Meteor.user()?.profile.numSlack or Meteor.user().profile.numSlack < 4

UI.registerHelper "hasOptedOutOfFeedback", ->
  userId = if typeof arguments[0] is "string" then arguments[0] else Session.get('selectedUserId')
  userProfile(userId)?.noFeedback

UI.registerHelper "isNumber", (number) ->
  _.isNumber(number) and not _.isNaN(number)