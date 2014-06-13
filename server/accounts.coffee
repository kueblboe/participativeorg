Accounts.onCreateUser (options, user) ->
  userinfo = Meteor.http.get("https://www.googleapis.com/oauth2/v2/userinfo",
    params:
      access_token: user.services.google.accessToken
  )
  throw userinfo.error if userinfo.error
  user.profile =
    firstname: userinfo.data.given_name
    lastname: userinfo.data.family_name
    avatar: userinfo.data.picture
    domain: userinfo.data.hd
    wantsEmailNotifications: true

  user
