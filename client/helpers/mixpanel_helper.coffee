Meteor.startup ->
  
  # Initialize Mixpanel Analytics
  if Meteor.settings?.public?.mixpanel?.token
    mixpanel.init Meteor.settings.public.mixpanel.token
  
  # Link their account
  Deps.autorun ->
    user = Meteor.user()
    return unless user?.services and user?.profile and "identify" of mixpanel
    mixpanel.identify user._id
    mixpanel.people.set
      name: user.profile.firstname + " " + user.profile.lastname
      domain: user.domain
      
      # special mixpanel property names
      $first_name: user.profile.firstname
      $email: email(user)
      $created: user.createdAt

    unless user.profile.initialized
      mixpanel.track('first sign in')
      Meteor.users.update(_id: Meteor.userId(), {$set: {"profile.initialized": true}})

@track = (event, data) ->
  if "track" of mixpanel
    mixpanel.track(event, data)