@Slack = new Meteor.Collection("slack")

upsertSlackWithCopies = (slack, slackAttributes) ->
  # get all the copies from the original
  if slackAttributes.copyOf
    original = Slack.findOne(slackAttributes.copyOf)
    slack.copies = _.without(_.union(original.copies, {slackId: original._id, userId: original.userId}), null, undefined)

  # check if own slack
  if slackAttributes._id
    existingSlack = Slack.findOne(slackAttributes._id)
    throw new Meteor.Error(422, "Can't update other people's activities") if existingSlack._id and existingSlack.userId isnt Meteor.userId()

  # add / update slack
  changes = Slack.upsert slackAttributes._id, { $set: slack }

  slackId = changes.insertedId || slackAttributes._id
  updateLatestActivity('flask', 'updated personal development activities', "pd/#{slackId}?userId=#{Meteor.userId()}")

  # update number of slack activities for user when adding slack
  if slack.userId is Meteor.userId()
    numSlack = Slack.find({userId: Meteor.userId()}).fetch().length
    Meteor.users.update({_id: Meteor.userId()}, { $set: {'profile.numSlack': numSlack} })

  # update all copies with new copy
  if slackAttributes.copyOf and changes.insertedId
    for copy in slack.copies
      copiedSlack = Slack.findOne(copy.slackId)
      newSlack = Slack.findOne(changes.insertedId)
      Slack.update(copiedSlack._id, { $set: {copies: _.without(_.union(copiedSlack.copies, {slackId: newSlack._id, userId: newSlack.userId}), null, undefined)} })

  changes

Meteor.methods(
  upsertSlack: (slackAttributes) ->
    throw new Meteor.Error(401, "You need to login to add an activity") unless Meteor.user()
    throw new Meteor.Error(422, "Please fill in a title") unless slackAttributes.title

    slack = pickWhitelistedAttributes(slackAttributes, "title", "description", "category", "date", "effort", "cost", "url", "ranking", "ignoreEffort", "ignoreCost")
    slack = _.extend slack,
      indicatedBy: undefined
      domain: Meteor.user().domain
      userName: "#{Meteor.user().profile.firstname} #{Meteor.user().profile.lastname}"

    changes = upsertSlackWithCopies(slack, slackAttributes)
    slackId = changes.insertedId || slackAttributes._id

    # create slack for all participants
    if slackAttributes.participants
      for participant in slackAttributes.participants
        participantSlack = _.extend(_.omit(slack, ['description', 'ranking']), {userId: participant, indicatedBy: Meteor.userId()})
        participantSlackAttributes = _.extend(_.omit(slackAttributes, '_id'), {copyOf: slackId})
        insert = upsertSlackWithCopies(participantSlack, participantSlackAttributes)
        createNotification({ slackId: insert.insertedId, ownerUserId: participant, userId: participant, action: "indicated that you took part in her/his", openEdit: true })

    changes

  removeSlack: (slackId) ->
    if Meteor.isServer
      slack = Slack.findOne(slackId)
      for copyId in _.pluck(slack.copies, 'slackId')
        if copy = Slack.findOne(copyId)
          Slack.update(copyId, { $set: {copies: (c for c in copy.copies when not _.isEqual(c, {slackId: slackId, userId: Meteor.userId()}))}})
    Slack.remove(slackId)
)
