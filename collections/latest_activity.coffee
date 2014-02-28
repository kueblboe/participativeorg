@updateLatestActivity = (icon, action, link) ->
  Meteor.users.update({_id: Meteor.userId()}, { $set: {'profile.latestActivity': {icon: icon, date: new Date(), action: action, link: link}} })