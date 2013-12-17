Handlebars.registerHelper "selectedSelf", ->
  Session.get('selectedUser')._id is Meteor.userId()

Handlebars.registerHelper "formattedDate", (date) ->
  moment(date).format('DD.MM.YYYY')

Handlebars.registerHelper "rfcDate", (date) ->
  moment(date).format('YYYY-MM-DD')

Handlebars.registerHelper "times", (n, block) ->
  accum = ""
  i = 0

  while i < n
    accum += block.fn(i)
    ++i
  accum
