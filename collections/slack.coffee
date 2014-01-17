@Slack = new Meteor.Collection("slack")

@upsertSlackWithCopies = (slack, slackAttributes) ->
  # get all the copies from the original
  if slackAttributes.copyOf
    original = Slack.findOne(slackAttributes.copyOf)
    slack.copies = _.without(_.union(original.copies, {slackId: original._id, userId: original.userId}), null, undefined)

  # add / update slack
  changes = Slack.upsert(slackAttributes._id, { $set: slack })

  # update all copies with new copy
  if slackAttributes.copyOf and changes.insertedId
    for copy in slack.copies
      copiedSlack = Slack.findOne(copy.slackId)
      newSlack = Slack.findOne(changes.insertedId)
      Slack.update(copiedSlack._id, { $set: {copies: _.without(_.union(copiedSlack.copies, {slackId: newSlack._id, userId: newSlack.userId}), null, undefined)} })

  changes

Meteor.methods(
  upsertSlack: (slackAttributes) ->
    throw new Meteor.Error(401, "You need to login to add slack") unless Meteor.user()
    throw new Meteor.Error(422, "Please fill in a title") unless slackAttributes.title
    throw new Meteor.Error(422, "Can't update other people's slack") if slackAttributes._id and slackAttributes.userId isnt Meteor.userId()

    # pick out the whitelisted keys and add userId and createdAt
    slack = _.extend(_.pick(slackAttributes, "title", "description", "category", "date", "effort", "cost", "url", "ranking"),
      indicatedBy: undefined
    )
    unless slackAttributes._id
      slack = _.extend(slack,
        userId: Meteor.userId()
        createdAt: new Date()
      )

    changes = upsertSlackWithCopies(slack, slackAttributes)

    # create slack for all participants
    if slackAttributes.participants
      for participant in slackAttributes.participants
        participantSlack = _.extend(_.omit(slack, ['description', 'ranking']), {userId: participant, indicatedBy: Meteor.userId()})
        participantSlackAttributes = _.extend(_.omit(slackAttributes, '_id'), {copyOf: changes.insertedId || slackAttributes._id})
        upsertSlackWithCopies(participantSlack, participantSlackAttributes)

    changes

  removeSlack: (slackId) ->
    if Meteor.isServer
      slack = Slack.findOne(slackId)
      for copyId in _.pluck(slack.copies, 'slackId')
        copy = Slack.findOne(copyId)
        if copy
          Slack.update(copyId, { $set: {copies: (c for c in copy.copies when not _.isEqual(c, {slackId: slackId, userId: Meteor.userId()}))}})
    Slack.remove(slackId)

  addSlackComment: (commentAttributes) ->
    throw new Meteor.Error(401, "You need to login to add a comment") unless Meteor.user()
    throw new Meteor.Error(422, "Please fill in a message") unless commentAttributes.body
    throw new Meteor.Error(422, "Which slack activity did you want to comment on?") unless commentAttributes.slackId
    
    # pick out the whitelisted keys and add userId and createdAt
    comment = _.extend(_.pick(commentAttributes, "body"),
      userId: Meteor.userId()
      createdAt: new Date()
    )

    slack = Slack.findOne(commentAttributes.slackId)
    Slack.update(slack._id, { $set: {comments: (slack.comments || []).concat comment} })
)
