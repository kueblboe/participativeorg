average = (mapping, month) ->
  satisfaction = Satisfaction.find({month: month}).fetch()
  satisfactionWithMapping = _.filter(satisfaction.map(mapping), (x) -> x)
  Math.round(satisfactionWithMapping.reduce(((x, sum) -> x + sum), 0) * 10 / satisfactionWithMapping.length) / 10

Template.satisfactionSummary.helpers
  averageScore: ->
    average(((s) -> s.score), @month)

  nextMonth: ->
    nextMonth(@month)

  previousMonth: ->
    previousMonth(@month)

  hasNextSatisfaction: ->
    Satisfaction.find({month: nextMonth(@month)}).count() > 0

  hasPreviousSatisfaction: ->
    Satisfaction.find({month: previousMonth(@month)}).count() > 0

Template.satisfactionSummary.events
  'click #next-month': (e) ->
    e.preventDefault()
    Session.set('selectedMonth', nextMonth(@month))

  'click #previous-month': (e) ->
    e.preventDefault()
    Session.set('selectedMonth', previousMonth(@month))