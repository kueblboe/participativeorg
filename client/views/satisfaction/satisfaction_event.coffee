Template.satisfactionEvent.helpers
  scoreCategory: ->
    npsCategory @score

  cellNames: ->
    if @cells
      cellNames(@cells)