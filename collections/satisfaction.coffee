@Satisfaction = new Meteor.Collection("satisfaction")

Satisfaction.allow
  update: ownsDocument

Satisfaction.deny update: (userId, satisfaction, fieldNames) ->
  # may only edit the following fields:
  _.without(fieldNames, "score", "body").length > 0

Meteor.methods(
  addSatisfaction: (satisfactionAttributes) ->
    month = moment().startOf('month').format('MM.YYYY')
    throw new Meteor.Error(401, "You need to login to add your satisfaction") unless Meteor.user()
    throw new Meteor.Error(401, "You already entered your satisfaction for month #{month}") if Satisfaction.findOne({userId: Meteor.userId(), month: month})

    satisfaction = pickWhitelistedAttributes(satisfactionAttributes, "score", "body")
    satisfaction = _.extend(satisfaction,
      domain: Meteor.user().profile.domain 
      cells: Meteor.user().profile.cells
      month: month
    )

    Satisfaction.insert satisfaction
)
