Template.slackEdit.helpers
  isActiveCategory: (category) ->
    if category is @category
      'active'

  users: ->
    alreadyPartOf = _.pluck(@copies, "userId").concat(Meteor.userId()).concat(@userId)
    Meteor.users.find({ _id: { $nin: alreadyPartOf } }, {sort: {'profile.name': 1}})

  hasUsersNotAlreadyPartOf: ->
    alreadyPartOf = _.pluck(@copies, "userId").concat(Meteor.userId()).concat(@userId)
    Meteor.users.find({ _id: { $nin: alreadyPartOf } }).fetch().length > 0

  hasCopies: ->
    @copies?.length > 0

  name: (userId) ->
    userProfile(userId)?.name

Template.slackEdit.events
  "submit form": (e) ->
    e.preventDefault()
    slackProperties =
      _id: @_id
      title: $(e.target).find("#title").val()
      description: $(e.target).find("#description").val()
      category: $(e.target).find("#category .active input").val()
      date: new Date($(e.target).find("#date").val())
      effort: parseInt($(e.target).find("#effort").val(), 10)
      cost: parseInt($(e.target).find("#cost").val(), 10)
      url: $(e.target).find("#url").val()
      ranking: parseInt($(e.target).find("#ranking").val(), 10)
      copyOf: @copyOf
      participants: $.map($("#coworkers input:checked"), (c) -> $(c).data("participant"))

    Meteor.call "upsertSlack", slackProperties, (error) ->
      if error
        throwError error.reason
      else
        track('upsert slack', { 'category': slackProperties.category })
        Router.go "slack"

  "click .delete": (e) ->
    e.preventDefault()
    if confirm("Delete this slack?")
      Meteor.call 'removeSlack', @_id, (error) ->
        if error
          throwError error.reason
        else
          track('remove slack')
          Router.go "slack"

  "click .dropdown-menu-form": (e) ->
    e.stopPropagation()