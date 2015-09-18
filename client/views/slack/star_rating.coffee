Template.starRating.helpers
  highlightRanking: ->
    'highlight' if @ranking > 4

  rankingList: ->
    [0...Math.round(@ranking)]

  rankingNegList: ->
    [0...(5 - Math.round(@ranking))] if @ranking

  numberOfRankings: ->
    actualRankings = _.filter(@rankings, (r) -> r)
    actualRankings.length unless @userId or actualRankings.length <= 1