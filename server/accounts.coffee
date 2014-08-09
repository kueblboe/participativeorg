capitalize = (string) ->
  string.charAt(0).toUpperCase() + string.substring(1).toLowerCase() if string

Accounts.emailTemplates.siteName = "participativeorg"
Accounts.emailTemplates.from = "Manuel <manuel@qualityswdev.com>"
Accounts.emailTemplates.resetPassword.text = (user, url) ->
   "Please follow this link to reset your password:\n\n#{url.replace('#/reset-password', 'recovery')}"

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
      domain: userinfo.data.hd
  else if user.services.password
    [email_name, domain] = user.emails[0].address.split('@')
    [firstname, middlenames..., lastname] = email_name.split('.')
    user.profile =
      firstname: capitalize(firstname)
      lastname: capitalize(lastname)
      avatar: Gravatar.imageUrl(user.emails[0].address, {d: 'retro'})
      domain: domain

  user.profile.wantsEmailNotifications = true
  user
