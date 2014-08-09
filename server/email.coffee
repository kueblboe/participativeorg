sendEmail = (that, to, from, subject, text) ->
  check [to, from, subject, text], [String]
  
  # Let other method calls from the same client start running, without waiting for the email sending to complete.
  that.unblock()

  receiver = Meteor.users.findOne(_id: to)

  if receiver.profile.wantsEmailNotifications
    Email.send
      to: email(receiver)
      from: from
      subject: subject
      text: "#{text}\n\n--\nDon't want to receive these emails? Edit your profile at #{Meteor.absoluteUrl 'profile'}"

Meteor.methods
  sendFeedbackEmail: (feedback) ->
    to = feedback.receiver
    from = "feedback@participativeorg.com"
    subject = "You received feedback"
    text = "#{feedback.body}\n\nSee all feedback for you and ask clarifying questions at #{Meteor.absoluteUrl 'feedback'}"
    sendEmail(this, to, from, subject, text)

  sendFeedbackReplyEmail: (reply, receiverId, feedback) ->
    to = receiverId
    from = "feedback@participativeorg.com"
    subject = "You received a reply to your feedback"
    text = "'#{reply.body}'\n\nAs reply to\n\n\'#{_.pluck(feedback.replies, 'body').join('\'\n\n\'')}\'\n\nSee all feedback for you and ask clarifying questions at #{Meteor.absoluteUrl 'feedback'}/?userId=#{feedback.receiver}"
    sendEmail(this, to, from, subject, text)
