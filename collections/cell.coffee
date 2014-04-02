@Cells = new Meteor.Collection("cells")

Cells.allow
  update: isInDomain
  insert: isInDomain

@cellNames = (cellIds) ->
  cells = Cells.find({ _id: { $in: cellIds } }).fetch()
  _.pluck(cells, 'name').join(', ')