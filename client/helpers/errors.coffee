# Local (client-only) collection
@Errors = new Meteor.Collection(null)

@throwError = (message) ->
  Errors.insert {message: message, seen: false}

 @clearErrors = ->
  Errors.remove seen: true