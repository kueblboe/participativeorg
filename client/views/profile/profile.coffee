Template.profile.events
  'keyup input#avatar': (e) ->
    $('#avatar-img').attr('src', $('input#avatar').val())

  "submit form": (e) ->
    e.preventDefault()
    $avatar = $(e.target).find("#avatar")
    $firstname = $(e.target).find("#firstname")
    $lastname = $(e.target).find("#lastname")
    profileProperties =
      profile =
        avatar: $(e.target).find("#avatar").val()
        firstname: $(e.target).find("#firstname").val()
        lastname: $(e.target).find("#lastname").val()

    console.log profileProperties
    Meteor.users.update({_id: Meteor.userId()}, {$set: {profile: profileProperties}})
    track('update profile')