@Cells = new Meteor.Collection("cells")

Cells.allow
  update: isInDomain
  insert: isInDomain