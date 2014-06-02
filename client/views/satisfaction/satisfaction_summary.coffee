satisfactionWithMapping = (mapping, month) ->
  satisfaction = Satisfaction.find({month: month}).fetch()
  _.filter(satisfaction.map(mapping), (x) -> x)

average = (mapping, month) ->
  satisfaction = satisfactionWithMapping(mapping, month)
  Math.round(satisfaction.reduce(((x, sum) -> x + sum), 0) * 10 / satisfaction.length) / 10

nps = (month) ->
  satisfaction = Satisfaction.find({month: month}).fetch()
  npsCount = _.countBy(satisfaction, (sat) ->
    if sat.score > 8
      'promoter'
    else if sat.score < 7
      'detractor'
    else
      'neutral'
  )
  _.defaults(npsCount, {promoter: 0, detractor: 0})
  Math.round((npsCount.promoter / satisfaction.length - npsCount.detractor / satisfaction.length) * 100)

Template.satisfactionSummary.helpers
  averageScore: ->
    average(((s) -> s.score), @month)

  eNps: ->
    nps(@month)

  numSatisfaction: ->
    Satisfaction.find({month: @month}).fetch().length

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