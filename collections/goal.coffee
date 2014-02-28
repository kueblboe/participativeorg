@Goals = new Meteor.Collection("goals")

Goals.allow
  update: ownsDocument
  remove: ownsDocument

Goals.deny update: (userId, goal, fieldNames) ->
  # may only edit the following fields:
  _.without(fieldNames, "description", "date").length > 0

Meteor.methods(
  addGoal: (goalAttributes) ->
    throw new Meteor.Error(401, "You need to login to add a goal") unless Meteor.user()
    throw new Meteor.Error(422, "Please fill in a description") unless goalAttributes.description
    
    # pick out the whitelisted keys
    goal = _.extend(_.pick(goalAttributes, "description", "date"),
      userId: Meteor.userId()
      createdAt: new Date()
    )

    goalId = Goals.insert(goal)
    updateLatestActivity('flag-checkered', 'updated slack goal', "slack/goal/#{goalId}?userId=#{Meteor.userId()}")
    goalId
)
