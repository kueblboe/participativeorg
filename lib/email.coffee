@email = (user) ->
  if user.services.google
    user.services.google.email
  else if user.services.password
    user.emails[0].address