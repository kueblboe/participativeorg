Template.profile.events
  'keyup input#avatar': (e) ->
    $('#avatar-img').attr('src', $('input#avatar').val())

  "submit form": (e) ->
    e.preventDefault()

    Meteor.users.update({_id: Meteor.userId()}, {$set:
        'profile.avatar': $(e.target).find("#avatar").val()
        'profile.firstname': $(e.target).find("#firstname").val()
        'profile.lastname': $(e.target).find("#lastname").val()
        'profile.wantsEmailNotifications': $(e.target).find("#wantsEmailNotifications").is(":checked")
    })
    track('update profile')
    Router.go "colleagues"