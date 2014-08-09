Template.login.events
  "submit #login-form": (e, t) ->
    e.preventDefault()
    email = t.find("#login-email").value
    password = t.find("#login-password").value
    
    Meteor.loginWithPassword email, password, (error) ->
      if error
        @throwError error.reason
      else
        Router.go 'colleagues'
    false

  "click #google-login-button": (e) ->
    e.preventDefault()
    Meteor.loginWithGoogle (error) ->
      if error
        @throwError error.reason
      else
        Router.go 'colleagues'