@startOfYear = (year) ->
  moment().year(year).startOf('year').toDate()

@endOfYear = (year) ->
  moment().year(year).endOf('year').toDate()

@startOfPreviousYear = (year) ->
  moment().year(parseInt(year) - 1).startOf('year').toDate()

@endOfNextYear = (year) ->
  moment().year(parseInt(year) + 1).endOf('year').toDate()