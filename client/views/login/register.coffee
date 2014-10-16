Session.set('verification-email-sent', false)

Template.register.helpers
  sent: ->
    Session.get('verification-email-sent')

Template.register.events
  "submit #register-form": (e, t) ->
    e.preventDefault()
    email = t.find("#register-email").value
    password = t.find("#register-password").value
    
    Accounts.createUser { email: email, password: password}, (error) ->
      if error
        if error.error is "unverified email"
          Session.set('verification-email-sent', true)
        else
          @throwError error.reason
      else
        Router.go 'colleagues'
    false

  "click #google-register-button": (e) ->
    e.preventDefault()
    Meteor.loginWithGoogle (error) ->
      if error
        @throwError error.reason
      else
        Router.go 'colleagues'
