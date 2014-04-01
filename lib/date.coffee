@startOfYear = (year) ->
  moment().year(year).startOf('year').toDate()

@endOfYear = (year) ->
  moment().year(year).endOf('year').toDate()

@startOfPreviousYear = (year) ->
  moment().year(parseInt(year) - 1).startOf('year').toDate()

@endOfNextYear = (year) ->
  moment().year(parseInt(year) + 1).endOf('year').toDate()

@month = ->
  moment().startOf('month').format('MM.YYYY')

@previousMonth = (month) ->
  moment("01.#{month}", "DD.MM.YYYY").subtract(1, 'month').startOf('month').format('MM.YYYY')

@nextMonth = (month) ->
  moment("01.#{month}", "DD.MM.YYYY").add(1, 'month').startOf('month').format('MM.YYYY')