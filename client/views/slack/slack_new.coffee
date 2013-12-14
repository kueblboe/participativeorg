Template.slackNew.events(
  'submit form': (e) ->
    e.preventDefault()
    slack =
      title: $(e.target).find("#title").val()
      description: $(e.target).find("#description").val()
      category: $(e.target).find("#category").val()
      date: $(e.target).find("#date").val()
      effort: $(e.target).find("#effort").val()
      cost: $(e.target).find("#cost").val()

    Meteor.call "addSlack", slack, (error, id) ->
      return alert(error.reason) if error
      Router.go "slackPage", { _id: id }
)