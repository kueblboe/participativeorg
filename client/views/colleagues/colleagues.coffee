Template.colleagues.helpers
  colleagueList: ->
    Meteor.users.find({}, {sort: {'profile.name': 1}})