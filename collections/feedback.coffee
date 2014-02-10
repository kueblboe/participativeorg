@Feedback = new Meteor.Collection("feedback")

Meteor.methods(
  addFeedback: (feedbackAttributes) ->
    throw new Meteor.Error(401, "You need to login to add feedback") unless Meteor.user()
    throw new Meteor.Error(422, "Please fill in a message") unless feedbackAttributes.body
    throw new Meteor.Error(422, "Can't figure out who you want to give feedback to") unless feedbackAttributes.receiver
    
    # pick out the whitelisted keys and add userId and createdAt
    feedback = _.extend(_.pick(feedbackAttributes, "body", "receiver"),
      userId: Meteor.userId()
      createdAt: new Date()
    )

    Feedback.insert(feedback, (error, id) ->
      if error
        throwError error.reason
      else
        createNotification({ feedbackId: id, userId: feedback.receiver, action: "someone gave you feedback", anonymous: true })
    )
)