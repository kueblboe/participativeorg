@Goals = new Meteor.Collection("goals")

Goals.allow
  update: (userId, goal) ->
    updateLatestActivity('flag-checkered', 'updated personal development goal', "pd/goal/#{goal._id}?userId=#{Meteor.userId()}")
    ownsDocument(userId, goal)
  remove: ownsDocument

Goals.deny update: (userId, goal, fieldNames) ->
  # may only edit the following fields:
  _.without(fieldNames, "description", "date").length > 0

Meteor.methods(
  addGoal: (goalAttributes) ->
    throw new Meteor.Error(401, "You need to login to add a goal") unless Meteor.user()
    throw new Meteor.Error(422, "Please fill in a description") unless goalAttributes.description

    goal = pickWhitelistedAttributes(goalAttributes, "description", "date")

    Goals.insert goal, (error, id) ->
      updateLatestActivity('flag-checkered', 'updated personal development goal', "pd/goal/#{id}?userId=#{Meteor.userId()}") unless error
)
