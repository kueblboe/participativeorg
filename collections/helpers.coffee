@pickWhitelistedAttributes = (object, whitelist...) ->
  filteredObject = _.pick object, whitelist
  filteredObject = _.extend filteredObject, { createdAt: new Date() } unless object._id
  filteredObject = _.extend filteredObject, { userId: Meteor.userId() } unless object.anonymous
  filteredObject

@updateLatestActivity = (icon, action, link) ->
  Meteor.users.update({_id: Meteor.userId()}, { $set: {'profile.latestActivity': {icon: icon, date: new Date(), action: action, link: link}} })