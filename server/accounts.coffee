capitalize = (string) ->
  string.charAt(0).toUpperCase() + string.substring(1).toLowerCase() if string

secondLevelDomain = (string) ->
  string.match(/[^\.\@]*\.[a-zA-Z]{2,}$/)[0]

Accounts.config
  sendVerificationEmail: true

Accounts.emailTemplates.siteName = "participativeorg"
Accounts.emailTemplates.from = "Manuel <manuel@qualityswdev.com>"
Accounts.emailTemplates.resetPassword.text = (user, url) ->
  "Please follow this link to reset your password:\n\n#{url}"
Accounts.emailTemplates.verifyEmail.subject = ->
  "Welcome to " + Accounts.emailTemplates.siteName

Accounts.urls.resetPassword = (token) ->
  Meteor.absoluteUrl "recovery/" + token

Accounts.urls.verifyEmail = (token) ->
  Meteor.absoluteUrl "verify-email/" + token

Accounts.onCreateUser (options, user) ->
  if user.services.google
    userinfo = Meteor.http.get("https://www.googleapis.com/oauth2/v2/userinfo",
      params:
        access_token: user.services.google.accessToken
    )
    throw userinfo.error if userinfo.error
    user.profile =
      firstname: capitalize(userinfo.data.given_name)
      lastname: capitalize(userinfo.data.family_name)
      avatar: userinfo.data.picture
    user.domain = userinfo.data.hd or secondLevelDomain(user.services.google.email)
  else if user.services.password
    [email_name, domain] = user.emails[0].address.split('@')
    [firstname, middlenames..., lastname] = email_name.split('.')
    user.profile =
      firstname: capitalize(firstname)
      lastname: capitalize(lastname)
      avatar: Gravatar.imageUrl(user.emails[0].address, {d: 'retro'})
    user.domain = secondLevelDomain(domain)

  user.profile.wantsEmailNotifications = true
  user

Accounts.validateLoginAttempt (attempt) ->
  if attempt.user and attempt.user.emails and not attempt.user.emails[0].verified
    throw new Meteor.Error("unverified email", "We need you to verify your email address before we can let you in. Please check your email.")
  true