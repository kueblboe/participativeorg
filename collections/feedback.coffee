@Feedback = new Meteor.Collection("feedback")

Meteor.methods(
  addFeedback: (feedbackAttributes) ->
    throw new Meteor.Error(401, "You need to login to add feedback") unless Meteor.user()
    throw new Meteor.Error(422, "Please fill in a message or recommendation score") unless feedbackAttributes.body or not _.isNaN(feedbackAttributes.recommend)
    throw new Meteor.Error(422, "Can't figure out who you want to give feedback to") unless feedbackAttributes.receiver

    feedback = pickWhitelistedAttributes(feedbackAttributes, "body", "recommend", "know", "receiver")

    Feedback.insert feedback, (error, id) ->
      if error
        throwError error.reason
      else
        createNotification({ feedbackId: id, ownerUserId: feedback.receiver, userId: feedback.receiver, action: "gave you", anonymous: true })

  addReply: (replyAttributes) ->
    throw new Meteor.Error(401, "You need to login to add a reply") unless Meteor.user()
    throw new Meteor.Error(422, "Please fill in a message") unless replyAttributes.body
    throw new Meteor.Error(422, "Can't figure out what you are trying to reply to") unless replyAttributes.replyTo

    reply = pickWhitelistedAttributes(replyAttributes, "body")

    if feedback = Feedback.findOne(replyAttributes.replyTo)
      Feedback.update(feedback._id, { $set: {replies: (feedback.replies || []).concat reply} })
      for userId in [feedback.receiver, feedback.userId]
        createNotification({ feedbackId: feedback._id, ownerUserId: feedback.receiver, userId: userId, action: "replied to your", anonymous: replyAttributes.anonymous })

  thank: (thankAttributes) ->
    throw new Meteor.Error(401, "You need to login to thank someone") unless Meteor.user()
    throw new Meteor.Error(422, "Can't figure out what you are trying to reply to") unless thankAttributes.replyTo

    if feedback = Feedback.findOne(thankAttributes.replyTo)
      Feedback.update(feedback._id, { $set: {thanked: true} })
      createNotification({ feedbackId: feedback._id, ownerUserId: feedback.receiver, userId: feedback.userId, action: "thanked you for your" })
)