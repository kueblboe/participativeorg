Template.satisfaction.helpers
  satisfactionEvents: ->
    Satisfaction.find({month: @month})

  cellNames: ->
    if cellIds = userProfile(Meteor.userId())?.cells
      cellNames(cellIds)