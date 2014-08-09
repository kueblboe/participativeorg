Session.set('sent', false)

Template.recovery.helpers
  sent: ->
    Session.get('sent')

Template.recovery.events
  "submit #recovery-form": (e, t) ->
    e.preventDefault()
    email = t.find("#recovery-email").value
    
    Accounts.forgotPassword {email: email}, (error) ->
      if error
        throwError error.reason
      else
        clearErrors
        Session.set('sent', true)
    false

  "submit #new-password-form": (e, t) ->
    e.preventDefault()
    password = t.find("#new-password").value
    
    Accounts.resetPassword @token, password, (error) ->
      if error
        throwError error.reason
      else
        Router.go 'colleagues'
    false

  "click #google-register-button": (e) ->
    e.preventDefault()
    Meteor.loginWithGoogle (error) ->
      if err
        throwError error.reason
      else
        Router.go 'colleagues'
