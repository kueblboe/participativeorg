Template.satisfaction.helpers
  satisfactionEvents: ->
    Satisfaction.find({month: @month}, {sort: {cells: 1}})

  cellNames: ->
    if cellIds = userProfile(Meteor.userId())?.cells
      cellNames(cellIds)