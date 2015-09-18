Template.slackTags.helpers
  hashtagSymbol: ->
    if /#freizeit/.test(@description)
      'moon-o'
    else if /#vortrag/.test(@description)
      'bullhorn'
    else if /#ausland/.test(@description)
      'suitcase'

  effort: ->
    Math.round @effort

  cost: ->
    Math.round @cost

  highlightEffort: ->
    'highlight' if @effort > 16

  highlightCost: ->
    'highlight' if @cost > 500

  highlightRanking: ->
    'highlight' if @ranking > 4

  rankingList: ->
    [0...Math.round(@ranking)]

  rankingNegList: ->
    [0...(5 - Math.round(@ranking))] if @ranking

  numberOfRankings: ->
    actualRankings = _.filter(@rankings, (r) -> r)
    actualRankings.length unless @userId or actualRankings.length <= 1